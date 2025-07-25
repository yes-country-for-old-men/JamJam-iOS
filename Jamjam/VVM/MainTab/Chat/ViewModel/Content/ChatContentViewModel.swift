//
//  ChatContentViewModel.swift
//  Jamjam
//
//  Created by 권형일 on 6/28/25.
//

import Foundation
import Combine
import os

@Observable
class ChatContentViewModel {
    let roomId: Int?
    let otherNickname: String?
    let otherProfileImageUrl: String?
    
    var messages: [ChatMessageDomainModel] = []
    
    var inputMessage = ""
    var isEditButtonTapped = false
    var isDeleteChatRoomAlertVisible = false
    var deleteChatRoomAlertMessage = "문제가 발생하였습니다. 다시 시도해 주세요."
    var isChatRoomDeleted = false
    
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored let logger = Logger(subsystem: "com.khi.jamjam", category: "ChatContentViewModel")
    
    init(roomId: Int?, nickname: String?, profileImageUrl: String?) {
        self.roomId = roomId
        self.otherNickname = nickname
        self.otherProfileImageUrl = profileImageUrl
        
        fetchChatMessages()
        
        subscribeStompChatRoom()
        StompManager.connect()
    }
    
    private func subscribeStompChatRoom() {
        // MARK: 연결 상태 라우터 구독
        StompCore.shared.socketConnectionStatusRouter
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("[socketConnectionStatusRouter] completion finished")
                case .failure(let error):
                    self?.logger.error("[socketConnectionStatusRouter] completion failed: \(error)")
                }
            } receiveValue: { [weak self] status in
                guard let self else { return }
                
                if case .connected = status {
                    guard let roomId else { return }
                    logger.info("[socketConnectionStatusRouter] 연결 상태 확인, 방 구독 시작, target roomId: \(roomId)")
                    StompManager.subscribeChatRoomMessage(roomId: roomId)
                }
            }
            .store(in: &cancellables)

        // MARK: 메시지 라우터 구독
        StompCore.shared.chatMessageReceivedRouter
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("[messageReceivedRouter] completion finished")
                case .failure(let error):
                    self?.logger.error("[messageReceivedRouter] completion failed: \(error)")
                }
            } receiveValue: { [weak self] chatMessage in
                self?.logger.info("[messageReceivedRouter] 디코딩 된 메시지 저장 시도")
                self?.messages.insert(chatMessage, at: 0)
            }
            .store(in: &cancellables)
    }
    
    private func fetchChatMessages() {
        guard let roomId else { return }
        let request = FetchChatMessagesRequestDto(page: 0, size: 20, sort: ["lastMessageTime,desc"])
        
        ChatManager.fetchChatMessages(request: request, chatRoomId: roomId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("[fetchChatMessages] completion finished")
                case .failure(let error):
                    self?.logger.error("[fetchChatMessages] completion failed: \(error)")
                }
            } receiveValue: { [weak self] response in
                if response.code == "SUCCESS" {
                    self?.logger.info("[fetchChatMessages] SUCCESS")
                    
                    if let chats = response.content?.chats, !chats.isEmpty {
                        self?.logger.info("[fetchChatMessages] 이전 메시지 존재")

                        self?.messages = chats.map { ChatMessageDomainModel(fromFetchChatMessagesResponse: $0) }
                        
                        /// 이후에 요청 최적화
                        self?.readLastMessage()
                        
                    } else {
                        self?.logger.info("[fetchChatMessages] 이전 메시지 없음")
                    }
                    
                } else {
                    self?.logger.error("[fetchChatMessages] 응답 처리 실패: \(response.message)")
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func readLastMessage() {
        guard let lastMessageId = messages.last?.messageId else { return }
        guard let roomId else { return }
        let request = ReadLastMessageRequestDto(lastReadMessageId: lastMessageId)
        
        ChatManager.readLastMessage(request: request, chatRoomId: roomId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("[readLastMessage] completion finished")
                case .failure(let error):
                    self?.logger.error("[readLastMessage] completion failed: \(error)")
                }
            } receiveValue: { [weak self] response in
                if response.code == "SUCCESS" {
                    self?.logger.info("[readLastMessage] SUCCESS")
                    
                } else {
                    self?.logger.error("[readLastMessage] 응답 처리 실패: \(response.message)")
                }
            }
            .store(in: &self.cancellables)
    }
    
    func send() {
        guard let roomId else { return }
        
        StompManager.sendMessage(roomId: roomId, text: inputMessage)
        
        DispatchQueue.main.async {
            self.inputMessage = ""
        }
    }
    
    func deleteChatRoom() {
        guard let roomId else { return }
        
        ChatManager.deleteChatRoom(targetChatRoomId: roomId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("[deleteChatRoom] completion finished")
                case .failure(let error):
                    self?.logger.error("[deleteChatRoom] completion failed: \(error)")
                    self?.isDeleteChatRoomAlertVisible = true
                }
            } receiveValue: { [weak self] response in
                if response.code == "SUCCESS" {
                    self?.logger.info("[deleteChatRoom] SUCCESS")
                    self?.isChatRoomDeleted = true
                    
                } else {
                    self?.logger.error("[deleteChatRoom] 응답 처리 실패: \(response.message)")
                    self?.isDeleteChatRoomAlertVisible = true
                    self?.deleteChatRoomAlertMessage = response.message
                }
            }
            .store(in: &self.cancellables)
    }
}
