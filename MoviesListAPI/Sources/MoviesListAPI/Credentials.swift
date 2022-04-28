//
//  Credentials.swift
//  Infrastructure
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation

/// Stores all credentials for Movies API.
public struct Credentials {
    
    public let apiKey: String
    public let baseURL: URL
    public let imagesBaseURL: URL
    
    static var current = Credentials(apiKey: "", baseURL: .init(fileURLWithPath: ""), imagesBaseURL: .init(fileURLWithPath: ""))
    
    init(apiKey: String, baseURL: URL, imagesBaseURL: URL) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.imagesBaseURL = imagesBaseURL
    }
    
    public static func initialize(apiKey: String, baseURL: URL, imagesBaseURL: URL) {
        current = .init(apiKey: apiKey, baseURL: baseURL, imagesBaseURL: imagesBaseURL)
    }
}
