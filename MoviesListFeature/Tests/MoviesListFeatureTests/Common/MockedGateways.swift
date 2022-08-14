//
//  MockedGateways.swift
//  
//
//  Created by Yan Schneider on 13/08/2022.
//

import Foundation
import Domain

class SuccessfulGetPopularMoviesGateway: GetPopularMoviesGateway {
    let totalPages: Int
    var page = 0
    
    init(totalPages: Int = 10) {
        self.totalPages = totalPages
    }
    
    func get(popularMovies: MoviesPage.Get) async throws -> MoviesPage {
        page += 1
        return Mocks.moviesPage(page: page, totalPages: totalPages)
    }
}

struct FailedGetPopularMoviesGateway: GetPopularMoviesGateway {
    
    func get(popularMovies: MoviesPage.Get) async throws -> MoviesPage {
        throw TestError.generic
    }
}

struct SuccessfulGetMovieDetailsGateway: GetMovieDetailsGateway {
    let title: String?
    
    init(title: String? = nil) {
        self.title = title
    }
    
    func get(movie: Domain.MovieDetails.Get) async throws -> Domain.MovieDetails {
        return Mocks.domainMovieDetails(id: movie.id, title: title ?? movie.id)
    }
}

struct FailedGetMovieDetailsGateway: GetMovieDetailsGateway {
    
    func get(movie: Domain.MovieDetails.Get) async throws -> Domain.MovieDetails {
        throw TestError.generic
    }
}

class SuccessfulFavoriteMovieGateway: SaveFavoriteMovieGateway, GetFavoriteMoviesGateway,
                                  DeleteFavoriteMovieGateway, CheckMovieIsFavoriteGateway {
    var movies = [FavoriteMovie]()
    
    func save(movie: FavoriteMovie) async throws {
        try await Task.sleep(nanoseconds: 1_000)
        movies.append(movie)
    }
    
    func get() async throws -> [FavoriteMovie] {
        try await Task.sleep(nanoseconds: 1_000)
        return movies
    }
    
    func delete(movie: FavoriteMovie.Delete) {
        movies.removeAll(where: { $0.id == movie.id })
    }
    
    func isFavorite(movie: FavoriteMovie.IsFavorite) -> Bool {
        return movies.contains(where: { $0.id == movie.id })
    }
}

class FailedFavoriteMovieGateway: SaveFavoriteMovieGateway, GetFavoriteMoviesGateway,
                                  DeleteFavoriteMovieGateway, CheckMovieIsFavoriteGateway {
    
    func save(movie: FavoriteMovie) async throws {
        throw TestError.generic
    }
    
    func get() async throws -> [FavoriteMovie] {
        throw TestError.generic
    }
    
    func delete(movie: FavoriteMovie.Delete) async throws {
        throw TestError.generic
    }
    
    func isFavorite(movie: FavoriteMovie.IsFavorite) async throws -> Bool {
        throw TestError.generic
    }
}
