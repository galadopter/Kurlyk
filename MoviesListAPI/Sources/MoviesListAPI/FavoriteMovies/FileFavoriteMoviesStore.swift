//
//  FileFavoriteMoviesStore.swift
//  
//
//  Created by Yan Schneider on 05/09/2022.
//

import Foundation
import Domain
import PersistenceKit

/// Stores favorite movies in a file storage with cache in memory
class FileFavoriteMoviesStore: Store<FavoriteMovieFileRepresentation> {
    
    init() {
        super.init(
            storage: Self.getStorage(),
            cache: SharedStorage.favoriteMoviesCache
        )
    }
}

// MARK: - GetFavoriteMoviesGateway
extension FileFavoriteMoviesStore: GetFavoriteMoviesGateway {
    
    public func get() async throws -> [Domain.FavoriteMovie] {
        try await get().map { .init(fileRepresentation: $0) }
    }
}

// MARK: - SaveFavoriteMovieGateway
extension FileFavoriteMoviesStore: SaveFavoriteMovieGateway {
    
    public func save(movie: Domain.FavoriteMovie) async throws {
        try await save(value: .init(domainModel: movie))
    }
}

// MARK: - DeleteFavoriteMovieGateway
extension FileFavoriteMoviesStore: DeleteFavoriteMovieGateway {
    
    public func delete(movie: Domain.FavoriteMovie.Delete) async throws {
        try await delete(id: movie.id)
    }
}

// MARK: - CheckMovieIsFavoriteGateway
extension FileFavoriteMoviesStore: CheckMovieIsFavoriteGateway {
    
    public func isFavorite(movie: Domain.FavoriteMovie.IsFavorite) async throws -> Bool {
        try await contains(id: movie.id)
    }
}

// MARK: - Initialization
private extension FileFavoriteMoviesStore {
    
    static let fileName = "FavoriteMovies"
    
    static func getStorage() -> any Storage<FavoriteMovieFileRepresentation, FavoriteMovieFileRepresentation.ID> {
        guard let worker = try? FileWorker(fileName: fileName) else {
            return SharedStorage.favoriteMoviesCache
        }
        
        return FileStorage(worker: worker)
    }
}
