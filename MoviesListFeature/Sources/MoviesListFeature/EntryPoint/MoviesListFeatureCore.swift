//
//  MoviesListFeatureCore.swift
//  
//
//  Created by Yan Schneider on 19/04/2022.
//

import Domain
import ComposableArchitecture

public enum TabViewPage: Equatable, Hashable {
    case moviesList
    case favoriteMovies
}

public struct MoviesListFeatureState: Equatable {
    @BindableState var currentTab: TabViewPage = .moviesList
    
    var moviesList: MoviesListState
    var favoriteMovies: FavoriteMoviesListState
    
    public init() {
        moviesList = .init()
        favoriteMovies = .init()
    }
}

public enum MoviesListFeatureAction: BindableAction, Equatable {
    case binding(BindingAction<MoviesListFeatureState>)
    case moviesList(MoviesListAction)
    case favoriteMovies(FavoriteMoviesListAction)
}

public struct MoviesListFeatureEnvironment {
    let mainQueue: AnySchedulerOf<DispatchQueue>
    let getPopularMoviesGateway: GetPopularMoviesGateway
    let getMovieDetailsGateway: GetMovieDetailsGateway
    let saveFavoriteMovieGateway: SaveFavoriteMovieGateway
    let getFavoriteMoviesGateway: GetFavoriteMoviesGateway
    let deleteFavoriteMovieGateway: DeleteFavoriteMovieGateway
    let checkMovieIsFavoriteGateway: CheckMovieIsFavoriteGateway
    
    public init(
        mainQueue: AnySchedulerOf<DispatchQueue>,
        getPopularMoviesGateway: GetPopularMoviesGateway,
        getMovieDetailsGateway: GetMovieDetailsGateway,
        saveFavoriteMovieGateway: SaveFavoriteMovieGateway,
        getFavoriteMoviesGateway: GetFavoriteMoviesGateway,
        deleteFavoriteMovieGateway: DeleteFavoriteMovieGateway,
        checkMovieIsFavoriteGateway: CheckMovieIsFavoriteGateway
    ) {
        self.mainQueue = mainQueue
        self.getPopularMoviesGateway = getPopularMoviesGateway
        self.getMovieDetailsGateway = getMovieDetailsGateway
        self.saveFavoriteMovieGateway = saveFavoriteMovieGateway
        self.getFavoriteMoviesGateway = getFavoriteMoviesGateway
        self.deleteFavoriteMovieGateway = deleteFavoriteMovieGateway
        self.checkMovieIsFavoriteGateway = checkMovieIsFavoriteGateway
    }
}

public let moviesListFeatureReducer = Reducer<MoviesListFeatureState, MoviesListFeatureAction, MoviesListFeatureEnvironment>.combine(
    moviesListReducer.pullback(
        state: \MoviesListFeatureState.moviesList,
        action: /MoviesListFeatureAction.moviesList,
        environment: { $0 }
    ),
    favoriteMoviesReducer.pullback(
        state: \MoviesListFeatureState.favoriteMovies,
        action: /MoviesListFeatureAction.favoriteMovies,
        environment: { $0 }
    ),
    
    Reducer { state, action, evironment in
        switch action {
        case .moviesList:
            return .none
        case .favoriteMovies(_):
            return .none
        case .binding(_):
            return .none
        }
    }.binding()
)
