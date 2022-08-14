//
//  File.swift
//  
//
//  Created by Yan Schneider on 08/08/2022.
//

import Foundation

public struct FavoriteMovie: Equatable {
    public let id: String
    public let title: String
    public let posterURL: URL
    
    public init(id: String, title: String, posterURL: URL) {
        self.id = id
        self.title = title
        self.posterURL = posterURL
    }
}
