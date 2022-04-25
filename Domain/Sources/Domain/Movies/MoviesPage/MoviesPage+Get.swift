//
//  MoviesPage+Get.swift
//  
//
//  Created by Yan Schneider on 25/04/2022.
//

import Foundation

public extension MoviesPage {
    
    struct Get {
        public let pageNumber: Int
        
        public init(pageNumber: Int) {
            self.pageNumber = pageNumber
        }
    }
}
