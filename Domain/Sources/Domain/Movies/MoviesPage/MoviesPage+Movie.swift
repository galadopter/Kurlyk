//
//  MoviesPage+MovieResult.swift
//  Domain
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation

extension MoviesPage {
    
    public struct Movie: Equatable {
        public let id: String
        public let title: String
        public let overview: String
        public let rating: Double
        public let posterURL: URL
        public let releaseDate: Date?
        
        public init(
            id: String,
            title: String,
            overview: String,
            rating: Double,
            posterURL: URL,
            releaseDate: Date?
        ) {
            self.id = id
            self.title = title
            self.overview = overview
            self.rating = rating
            self.posterURL = posterURL
            self.releaseDate = releaseDate
        }
    }
}
