//
//  NotificationViewModel.swift
//  Jamjam
//
//  Created by 권형일 on 7/12/25.
//

import Foundation

@Observable
class EditNotificationViewModel {
    var isLogin: Bool {
        AuthCore.shared.isLogin
    }
    
    var eventNotification = true
    var orderNotification = true
    var chatNotification = true
}
