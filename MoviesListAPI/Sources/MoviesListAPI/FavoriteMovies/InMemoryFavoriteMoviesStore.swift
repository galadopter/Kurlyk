//
//  File.swift
//  
//
//  Created by Yan Schneider on 12/08/2022.
//

import Foundation
import Domain

/// Holds favorite movies in the memory
class InMemoryFavoriteMoviesStore {
    
    private var movies: [FavoriteMovie]
    
    init(initialValue movies: [FavoriteMovie] = []) {
        self.movies = movies
    }
    
    /// Singletone version of store
    static let shared = InMemoryFavoriteMoviesStore()
}

// MARK: - FavoriteMoviesStore
extension InMemoryFavoriteMoviesStore: FavoriteMoviesStore {
    
    func get() async throws -> [FavoriteMovie] {
        movies
    }
    
    func save(movie: FavoriteMovie) async throws {
        movies.append(movie)
    }
    
    func delete(movie: FavoriteMovie.Delete) async throws {
        movies.removeAll(where: { $0.id == movie.id })
    }
    
    func isFavorite(movie: FavoriteMovie.IsFavorite) async throws -> Bool {
        movies.contains(where: { $0.id == movie.id })
    }
}
