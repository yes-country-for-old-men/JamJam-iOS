//
//  ServiceGenerateResponseDto.swift
//  Jamjam
//
//  Created by 권형일 on 7/7/25.
//

import Foundation

struct GenerateServiceResponseDto: Decodable {
    let code: String
    let message: String
    let content: Content?
    
    struct Content: Decodable {
        let serviceNames: [String]
        let category: Int
        let description: String
    }
}
