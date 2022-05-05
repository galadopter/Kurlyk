//
//  Movie+Get.swift
//  Domain
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation

extension MovieDetails {
    
    public struct Get: Equatable {
        public let id: String
        
        public init(id: String) {
            self.id = id
        }
    }
}
