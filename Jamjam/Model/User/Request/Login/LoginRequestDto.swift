//
//  LoginRequest.swift
//  Jamjam
//
//  Created by 권형일 on 6/27/25.
//

import Foundation

struct LoginRequestDto: Encodable {
    let loginId: String
    let password: String
}
