//
//  User+Create.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

public extension User {
    
    struct Create {
        public let email: String
        public let password: String
        public let name: String
        public let biography: String
        
        public init(email: String, password: String, name: String, biography: String) {
            self.email = email
            self.password = password
            self.name = name
            self.biography = biography
        }
    }
}
