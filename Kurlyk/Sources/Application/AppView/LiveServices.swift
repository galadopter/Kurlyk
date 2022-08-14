//
//  LiveServices.swift
//  Kurlyk
//
//  Created by Yan Schneider on 12/08/2022.
//

import Foundation
import AuthenticationFeature
import MoviesListAPI
import MoviesListFeature
import ComposableArchitecture

// MARK: - Live AppEnvironment
extension AppEnvironment {
    
    static let live = AppEnvironment(
        mainQueue: .main
    )
}

// MARK: - Live MoviesListFeatureEnvironment
extension MoviesListFeatureEnvironment {
    
    static let live: MoviesListFeatureEnvironment = {
        let service = MoviesService()
        let store = FavoriteMoviesStoreFabric.provide()
        
        return .init(
           mainQueue: .main,
           getPopularMoviesGateway: service,
           getMovieDetailsGateway: service,
           saveFavoriteMovieGateway: store,
           getFavoriteMoviesGateway: store,
           deleteFavoriteMovieGateway: store,
           checkMovieIsFavoriteGateway: store
       )
    }()
}
