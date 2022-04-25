//
//  Movie.swift
//  Domain
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation

public struct MovieDetails: Equatable {
    public let id: String
    public let title: String
    public let overview: String
    public let rating: Double
    public let duration: Int?
    public let releaseDate: Date?
    public let posterURL: URL
    public let genres: [Genre]
    
    public struct Genre: Equatable {
        public let name: String
        
        public init(name: String) {
            self.name = name
        }
    }
    
    public init(
        id: String,
        title: String,
        overview: String,
        rating: Double,
        duration: Int?,
        releaseDate: Date?,
        posterURL: URL,
        genres: [Genre]
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.rating = rating
        self.duration = duration
        self.releaseDate = releaseDate
        self.posterURL = posterURL
        self.genres = genres
    }
}
