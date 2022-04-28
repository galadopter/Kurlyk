//
//  MoviesPage.swift
//  Infrastructure
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation
import Domain

struct MoviesPageResponse: Codable {
    let page: Int
    let totalPages: Int
    let movies: [MovieResponse]
    
    enum CodingKeys: String, CodingKey {
        case page, totalPages = "total_pages", movies = "results"
    }
}

// MARK: - Mapping to domain model
extension MoviesPage {
    
    init(response: MoviesPageResponse) {
        self.init(
            page: response.page,
            totalPages: response.totalPages,
            movies: response.movies.map { .init(response: $0) }
        )
    }
}
