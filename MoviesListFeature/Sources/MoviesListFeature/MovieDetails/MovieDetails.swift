//
//  MovieDetails.swift
//  
//
//  Created by Yan Schneider on 03/05/2022.
//

import Foundation
import Domain

public struct MovieDetails: Equatable {
    var title: String
    var posterURL: URL
    var overview: String
    var releaseDate: String
    var isFavorite: Bool
}

// MARK: - Domain mapping
extension MovieDetails {
    
    init(domain: Domain.MovieDetails, isFavorite: Bool, dateFormatter: DateFormatter) {
        self.title = domain.title
        self.posterURL = domain.posterURL
        self.overview = domain.overview
        self.releaseDate = domain.releaseDate.map { dateFormatter.string(from: $0) } ?? ""
        self.isFavorite = isFavorite
    }
}

// MARK: - Mapping to Domain
extension FavoriteMovie {
    
    init(details: MovieDetails, id: String) {
        self.init(id: id, title: details.title, posterURL: details.posterURL)
    }
}
