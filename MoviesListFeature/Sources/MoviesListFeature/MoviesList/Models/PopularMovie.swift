//
//  PopularMovie.swift
//  
//
//  Created by Yan Schneider on 26/04/2022.
//

import Foundation
import Domain

public struct PopularMovie: Equatable, Identifiable {
    public let id: String
    public let title: String
    public let releaseDate: String
    public let rating: Double
    public let posterURL: URL
}

// MARK: - Domain
extension PopularMovie {
    
    init(domain: Domain.MoviesPage.Movie, dateFormatter: DateFormatter) {
        id = domain.id
        title = domain.title
        releaseDate = domain.releaseDate.map { dateFormatter.string(from: $0) } ?? ""
        rating = domain.rating
        posterURL = domain.posterURL
    }
}
