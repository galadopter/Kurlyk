//
//  TestEnvironment.swift
//  
//
//  Created by Yan Schneider on 12/08/2022.
//

import Foundation
import ComposableArchitecture
import Domain
import MoviesListFeature

extension MoviesListFeatureEnvironment {
    
    static func test(
        getPopularMoviesGateway: SuccessfulGetPopularMoviesGateway = .init(),
        getMovieDetailsGateway: SuccessfulGetMovieDetailsGateway = .init(),
        favoriteMoviesGateway: SuccessfulFavoriteMovieGateway = .init()
    ) -> MoviesListFeatureEnvironment {
        return .init(
            mainQueue: .main,
            getPopularMoviesGateway: getPopularMoviesGateway,
            getMovieDetailsGateway: getMovieDetailsGateway,
            saveFavoriteMovieGateway: favoriteMoviesGateway,
            getFavoriteMoviesGateway: favoriteMoviesGateway,
            deleteFavoriteMovieGateway: favoriteMoviesGateway,
            checkMovieIsFavoriteGateway: favoriteMoviesGateway
        )
    }
    
    static var failedTest: MoviesListFeatureEnvironment {
        let favoriteMoviesGateway = FailedFavoriteMovieGateway()
        return .init(
            mainQueue: .main,
            getPopularMoviesGateway: FailedGetPopularMoviesGateway(),
            getMovieDetailsGateway: FailedGetMovieDetailsGateway(),
            saveFavoriteMovieGateway: favoriteMoviesGateway,
            getFavoriteMoviesGateway: favoriteMoviesGateway,
            deleteFavoriteMovieGateway: favoriteMoviesGateway,
            checkMovieIsFavoriteGateway: favoriteMoviesGateway
        )
    }
}
