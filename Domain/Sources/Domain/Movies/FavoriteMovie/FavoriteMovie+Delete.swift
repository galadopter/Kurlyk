//
//  File.swift
//  
//
//  Created by Yan Schneider on 08/08/2022.
//

import Foundation

extension FavoriteMovie {
    
    public struct Delete: Equatable {
        public let id: String
        
        public init(id: String) {
            self.id = id
        }
    }
}
