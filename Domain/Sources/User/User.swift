//
//  User.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

public struct User: Equatable {
    public let email: String
    public let name: String
    public let biography: String
    
    public init(email: String, name: String, biography: String) {
        self.email = email
        self.name = name
        self.biography = biography
    }
}
