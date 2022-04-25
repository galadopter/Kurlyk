//
//  MoviesPage.swift
//  Domain
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation

public struct MoviesPage: Equatable, HasTotalPages {
    public let page: Int
    public let totalPages: Int
    public let movies: [Movie]
    
    public init(page: Int, totalPages: Int, movies: [Movie]) {
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }
}
