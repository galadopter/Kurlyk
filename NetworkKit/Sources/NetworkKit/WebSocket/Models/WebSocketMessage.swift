//
//  WebSocketMessage.swift
//  Infrastructure
//
//  Created by Yan Schneider on 19/05/2022.
//

import Foundation

struct WebSocketMessage<Body: Codable>: Codable {
    let type: String
    let id: String
    let body: Body
    
    enum CodingKeys: String, CodingKey {
        case type = "t", id, body
    }
}
