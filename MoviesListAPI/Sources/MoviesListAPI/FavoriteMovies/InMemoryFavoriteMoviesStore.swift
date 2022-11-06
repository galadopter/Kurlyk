//
//  File.swift
//  
//
//  Created by Yan Schneider on 12/08/2022.
//

import Foundation
import Domain

/// Holds favorite movies in the memory
actor InMemoryFavoriteMoviesStore {
    
    private var movies: [String: FavoriteMovie]
    
    init(initialValue movies: [FavoriteMovie] = []) {
        var newMovies = [String: FavoriteMovie]()
        for movie in movies {
            newMovies[movie.id] = movie
        }
        self.movies = newMovies
    }
    
    /// Singletone version of store
    static let shared = InMemoryFavoriteMoviesStore()
}

// MARK: - GetFavoriteMoviesGateway
extension InMemoryFavoriteMoviesStore: GetFavoriteMoviesGateway {
    
    func get() async throws -> [FavoriteMovie] {
        movies.map { $0.value }
    }
}

// MARK: - DeleteFavoriteMovieGateway
extension InMemoryFavoriteMoviesStore: DeleteFavoriteMovieGateway {
    
    func save(movie: FavoriteMovie) async throws {
        movies[movie.id] = movie
    }
}

// MARK: - DeleteFavoriteMovieGateway
extension InMemoryFavoriteMoviesStore: SaveFavoriteMovieGateway {
    
    func delete(movie: FavoriteMovie.Delete) async throws {
        movies[movie.id] = nil
    }
}

// MARK: - DeleteFavoriteMovieGateway
extension InMemoryFavoriteMoviesStore: CheckMovieIsFavoriteGateway {
    
    func isFavorite(movie: FavoriteMovie.IsFavorite) async throws -> Bool {
        movies[movie.id] != nil
    }
}
