//
//  User+Get.swift
//  Domain
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation

public extension User {
    
    struct Get {
        public let email: String
        public let password: String
        
        public init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
}
