//
//  SendSmsResponse.swift
//  Jamjam
//
//  Created by 권형일 on 6/25/25.
//

import Foundation

struct SendSmsResponseDto: Decodable {
    let code: String
    let message: String
    let content: Content?
    
    struct Content: Decodable {
        
    }
}
