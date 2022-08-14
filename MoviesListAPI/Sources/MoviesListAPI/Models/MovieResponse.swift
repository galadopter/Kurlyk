//
//  MovieResponse.swift
//  Infrastructure
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation
import Domain

struct MovieResponse: Codable {
    let id: UInt
    let title: String
    let releaseDate: String?
    let duration: Int?
    let rating: Double
    let posterPath: String?
    let overview: String
    let genres: [Genre]?
    
    struct Genre: Codable {
        let name: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, releaseDate = "release_date", duration = "runtime", rating = "vote_average", posterPath = "poster_path", overview, genres
    }
}

// MARK: - Mapping to domain model
extension MoviesPage.Movie {
    
    init(response: MovieResponse) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        self.init(
            id: String(response.id),
            title: response.title,
            overview: response.overview,
            rating: response.rating / 10,
            posterURL: Credentials.current.imagesBaseURL.appendingPathComponent(response.posterPath ?? ""),
            releaseDate: response.releaseDate.flatMap { dateFormatter.date(from: $0) }
        )
    }
}

// MARK: - Mapping to domain model
extension MovieDetails {
    
    init(response: MovieResponse) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        self.init(
            id: String(response.id),
            title: response.title,
            overview: response.overview,
            rating: response.rating / 10,
            duration: response.duration,
            releaseDate: response.releaseDate.flatMap { dateFormatter.date(from: $0) },
            posterURL: Credentials.current.imagesBaseURL.appendingPathComponent(response.posterPath ?? ""),
            genres: response.genres?.map { .init(name: $0.name) } ?? []
        )
    }
}
