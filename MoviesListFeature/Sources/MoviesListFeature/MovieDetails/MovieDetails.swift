//
//  MovieDetails.swift
//  
//
//  Created by Yan Schneider on 03/05/2022.
//

import Foundation
import Domain

struct MovieDetails: Equatable {
    let title: String
    let posterURL: URL
    let overview: String
    let releaseDate: String
}

// MARK: - Domain mapping
extension MovieDetails {
    
    init(domain: Domain.MovieDetails, dateFormatter: DateFormatter) {
        self.title = domain.title
        self.posterURL = domain.posterURL
        self.overview = domain.overview
        self.releaseDate = domain.releaseDate.map { dateFormatter.string(from: $0) } ?? ""
    }
}
