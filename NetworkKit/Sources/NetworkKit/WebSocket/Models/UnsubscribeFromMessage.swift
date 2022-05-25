//
//  UnsubscribeFromMessage.swift
//  Infrastructure
//
//  Created by Yan Schneider on 19/05/2022.
//

import Foundation

struct UnsubscribeFromMessage: Codable {
    let products: [String]
    
    enum CodingKeys: String, CodingKey {
        case products = "unsubscribeFrom"
    }
}
