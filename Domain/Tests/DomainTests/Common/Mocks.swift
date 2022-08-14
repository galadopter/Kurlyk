//
//  Mocks.swift
//  DomainTests
//
//  Created by Yan Schneider on 15.11.21.
//

import Foundation
import Domain

struct Mocks {
    
    static func createUser(
        email: String = "test@example.com",
        password: String = "abcd1234",
        name: String = "Test User",
        biography: String = "Some interesting information"
    ) -> User.Create {
        .init(
            email: email,
            password: password,
            name: name,
            biography: biography
        )
    }
    
    static func movieDetails(
        id: String = "1",
        title: String = "",
        overview: String = "",
        rating: Double = 1,
        duration: Int? = 1,
        releaseDate: Date = Date(),
        posterURL: URL = URL(fileURLWithPath: ""),
        genres: [MovieDetails.Genre] = []
    ) -> MovieDetails {
        .init(
            id: id,
            title: title,
            overview: overview,
            rating: rating,
            duration: duration,
            releaseDate: releaseDate,
            posterURL: posterURL,
            genres: genres
        )
    }
    
    static func movie(
        id: String = "1",
        title: String = "",
        overview: String = "",
        rating: Double = 1,
        posterURL: URL = URL(fileURLWithPath: ""),
        releaseDate: Date = Date()
    ) -> MoviesPage.Movie {
        .init(
            id: id,
            title: title,
            overview: overview,
            rating: rating,
            posterURL: posterURL,
            releaseDate: releaseDate
        )
    }
    
    static func moviesPage(
        page: Int = 1,
        totalPages: Int = 2,
        movies: [MoviesPage.Movie] = [movie()]
    ) -> MoviesPage {
        .init(
            page: page,
            totalPages: totalPages,
            movies: movies
        )
    }
    
    static func error(
        error: TestError = .generic
    ) -> Error {
        error
    }
}
