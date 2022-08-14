//
//  File.swift
//  
//
//  Created by Yan Schneider on 30/05/2022.
//

import Foundation
import Domain

public extension MoviesListFeatureEnvironment {
    
    /// Mocked environment
    static let mock: MoviesListFeatureEnvironment = {
        let favoriteMoviesGateway = MockedFavoriteMovieGateway()
        return .init(
            mainQueue: .main,
            getPopularMoviesGateway: MockedGetPopularMoviesGateway(),
            getMovieDetailsGateway: MockedMovieDetailsGateway(),
            saveFavoriteMovieGateway: favoriteMoviesGateway,
            getFavoriteMoviesGateway: favoriteMoviesGateway,
            deleteFavoriteMovieGateway: favoriteMoviesGateway,
            checkMovieIsFavoriteGateway: favoriteMoviesGateway
        )
    }()
}

class MockedGetPopularMoviesGateway: GetPopularMoviesGateway {
    let bladeRunnerPoster = URL(string: "https://upload.wikimedia.org/wikipedia/en/9/9f/Blade_Runner_%281982_poster%29.png")!
    var page = 0
    
    func get(popularMovies: MoviesPage.Get) async throws -> MoviesPage {
        try await Task.sleep(nanoseconds: 500_000_000)
        page += 1
        let movies: [MoviesPage.Movie] = (1...10).map {
            .init(id: UUID().uuidString, title: "\((10 * (page - 1)) + $0)", overview: "", rating: 0.95, posterURL: bladeRunnerPoster, releaseDate: .now)
        }
        return .init(page: page, totalPages: 10, movies: movies)
    }
}

struct MockedMovieDetailsGateway: GetMovieDetailsGateway {
    let bladeRunnerPoster = URL(string: "https://upload.wikimedia.org/wikipedia/en/9/9f/Blade_Runner_%281982_poster%29.png")!
    
    func get(movie: Domain.MovieDetails.Get) async throws -> Domain.MovieDetails {
        try await Task.sleep(nanoseconds: 500_000_000)
        return .init(id: movie.id, title: "Blade runner", overview: "", rating: 0, duration: 0, releaseDate: nil, posterURL: bladeRunnerPoster, genres: [])
    }
}

class MockedFavoriteMovieGateway: SaveFavoriteMovieGateway, GetFavoriteMoviesGateway,
                                  DeleteFavoriteMovieGateway, CheckMovieIsFavoriteGateway {
    var movies = [FavoriteMovie]()
    
    func save(movie: FavoriteMovie) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        movies.append(movie)
    }
    
    func get() async throws -> [FavoriteMovie] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return movies
    }
    
    func delete(movie: FavoriteMovie.Delete) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        movies.removeAll(where: { $0.id == movie.id })
    }
    
    func isFavorite(movie: FavoriteMovie.IsFavorite) async throws -> Bool {
        try await Task.sleep(nanoseconds: 500_000_000)
        return movies.contains(where: { $0.id == movie.id })
    }
}
