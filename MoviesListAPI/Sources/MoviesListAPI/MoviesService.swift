//
//  MoviesService.swift
//  Infrastructure
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation
import Domain
import NetworkKit

/// Network service for Movies API
public class MoviesService: NetworkService<MoviesAPI> {
    
    func getPopularMovies(page: Int) async throws -> MoviesPageResponse {
        try await network.fetch(.popular(page: page))
    }
    
    func getMovieDetails(id: String) async throws -> MovieResponse {
        try await network.fetch(.details(id: id))
    }
}

// Conforming to Domain absctractions

// MARK: - GetPopularMoviesGateway
extension MoviesService: GetPopularMoviesGateway {
    
    public func get(popularMovies: MoviesPage.Get) async throws -> MoviesPage {
        let response = try await getPopularMovies(page: popularMovies.pageNumber)
        
        return .init(response: response)
    }
}

// MARK: - GetMovieDetailsGateway
extension MoviesService: GetMovieDetailsGateway {
    
    public func get(movie: MovieDetails.Get) async throws -> MovieDetails {
        let response = try await getMovieDetails(id: movie.id)
        
        return .init(response: response)
    }
}
