//
//  WebSocketEndpoint.swift
//  Infrastructure
//
//  Created by Yan Schneider on 19/05/2022.
//

import Foundation

public struct WebSocketEndpoint {
    public let url: URL
    public let headers: [String: String]
    
    public init(url: URL, headers: [String: String]) {
        self.url = url
        self.headers = headers
    }
}
