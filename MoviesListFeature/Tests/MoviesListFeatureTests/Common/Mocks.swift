//
//  Mocks.swift
//  
//
//  Created by Yan Schneider on 12/08/2022.
//

import Foundation
import Domain

@testable import MoviesListFeature

struct Mocks {
    
    static func domainMovieDetails(
        id: String = "1",
        title: String = "",
        overview: String = "",
        rating: Double = 1,
        duration: Int? = 1,
        releaseDate: Date = Date(timeIntervalSince1970: 1233245324),
        posterURL: URL = URL(fileURLWithPath: ""),
        genres: [Domain.MovieDetails.Genre] = []
    ) -> Domain.MovieDetails {
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
    
    static func movieDetails(
        title: String = "",
        posterURL: URL = URL(fileURLWithPath: ""),
        overview: String = "",
        releaseDate: String = "Jan 29, 2009",
        isFavorite: Bool = false
    ) -> MoviesListFeature.MovieDetails {
        .init(
            title: title,
            posterURL: posterURL,
            overview: overview,
            releaseDate: releaseDate,
            isFavorite: isFavorite
        )
    }
    
    static func movie(
        id: String = "1",
        title: String = "",
        overview: String = "",
        rating: Double = 1,
        posterURL: URL = URL(fileURLWithPath: ""),
        releaseDate: Date = Date(timeIntervalSince1970: 1233245324)
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
        totalPages: Int = 10,
        movies: [MoviesPage.Movie]? = nil
    ) -> MoviesPage {
        .init(
            page: page,
            totalPages: totalPages,
            movies: movies == nil
                ? (1...10).map { movie(id: "\(10 * (page - 1) + $0)", title: "\(10 * (page - 1) + $0)") }
                : movies!
        )
    }
    
    static func paginationPage(
        pagination: PaginationCounter = .init(),
        result: MoviesPage = moviesPage()
    ) -> PaginationUseCase<MoviesPage>.Output {
        .init(
            pagination: pagination,
            result: result
        )
    }
    
    static func popularMovie(
        id: String = "",
        title: String = "",
        releaseDate: String = "Jan 29, 2009",
        rating: Double = 1,
        posterURL: URL = URL(fileURLWithPath: "")
    ) -> PopularMovie {
        .init(
            id: id,
            title: title,
            releaseDate: releaseDate,
            rating: rating,
            posterURL: posterURL
        )
    }
    
    static func favoriteMovie(
        id: String = "",
        title: String = "",
        posterURL: URL = URL(fileURLWithPath: "")
    ) -> FavoriteMovie {
        .init(
            id: id,
            title: title,
            posterURL: posterURL
        )
    }
    
    static func error(
        error: TestError = .generic
    ) -> Error {
        error
    }
}

enum TestError: Error {
    case generic
}

// MARK: - Mocked Gateways

