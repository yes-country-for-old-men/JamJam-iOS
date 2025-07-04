//
//  ChatViewModel.swift
//  Jamjam
//
//  Created by 권형일 on 6/28/25.
//

import Foundation
import Combine
import os

@Observable
class ChatListViewModel {
    var chatRooms: [ChatRoomModel] = []
    
    var isStompClientInitPossible: Bool {
        !AuthCenter.shared.isStompClientInit && AuthCenter.shared.isLogin
    }
    
    @ObservationIgnored var cancellables = Set<AnyCancellable>()
    @ObservationIgnored let logger = Logger(subsystem: "com.khi.jamjam", category: "ChatViewModel")
    
    func fetchChatRooms() {
        let request = FetchChatRoomsRequest(page: 0, size: 20, sort: ["lastMessageTime,desc"])
        
        ChatManager.shared.fetchChatRooms(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.logger.info("[fetchChatRooms] completion finished")
                case .failure(let error):
                    self?.logger.error("[fetchChatRooms] completion failed: \(error)")
                }
            } receiveValue: { [weak self] response in
                if response.code == "SUCCESS" {
                    self?.logger.info("[fetchChatRooms] SUCCESS")
                    
                    if let rooms = response.content?.rooms {
                        let chatRooms = rooms.map {
                            ChatRoomModel(fromFetchChatRoomsResponse: $0)
                        }
                        self?.chatRooms = chatRooms
                    }
                    
                } else {
                    self?.logger.error("[fetchChatRooms] 에러 발생: \(response.message)")
                }
            }
            .store(in: &cancellables)
    }
    
    func initStompClient() {
        ChatManager.shared.initStompClient()
    }
}
