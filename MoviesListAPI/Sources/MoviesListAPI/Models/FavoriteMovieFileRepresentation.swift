//
//  FavoriteMovieFileRepresentation.swift
//  
//
//  Created by Yan Schneider on 05/11/2022.
//

import Foundation
import Domain

struct FavoriteMovieFileRepresentation: Codable, Identifiable {
    let id: String
    let title: String
    let posterURL: URL
}

// MARK: - From Domain to File
extension FavoriteMovieFileRepresentation {
    
    init(domainModel: FavoriteMovie) {
        self.id = domainModel.id
        self.title = domainModel.title
        self.posterURL = domainModel.posterURL
    }
}

// MARK: - From File to Domain
extension FavoriteMovie {
    
    init(fileRepresentation: FavoriteMovieFileRepresentation) {
        self.init(
            id: fileRepresentation.id,
            title: fileRepresentation.title,
            posterURL: fileRepresentation.posterURL
        )
    }
}
