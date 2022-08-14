//
//  TestHelper.swift
//  Infrastructure
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation

@testable import MoviesListAPI

struct GenericModel: Codable, Equatable {
    let testField: Int
}

enum Mocks {
    
    static func moviesResponse(
        id: UInt = 0,
        title: String = "",
        releaseDate: String = "2020-12-23",
        duration: Int? = nil,
        rating: Double = 0,
        posterPath: String = "",
        overview: String = "",
        genres: [MovieResponse.Genre]? = []
    ) -> MovieResponse {
        .init(
            id: id,
            title: title,
            releaseDate: releaseDate,
            duration: duration,
            rating: rating,
            posterPath: posterPath,
            overview: overview,
            genres: genres
        )
    }
    
    static func moviesPageResponse(
        page: Int = 1,
        totalPages: Int = 2,
        movies: [MovieResponse] = [moviesResponse()]
    ) -> MoviesPageResponse {
        .init(page: page, totalPages: totalPages, movies: movies)
    }
}

enum TestError: Error {
    case generic
}

func makeHTTPResponse(statusCode: Int) -> HTTPURLResponse? {
    .init(url: MoviesAPI.details(id: "1").baseURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)
}
