//
//  MoviesListView.swift
//  
//
//  Created by Yan Schneider on 19/04/2022.
//

import SwiftUI
import ComposableArchitecture
import ComponentsKit
import DesignSystem

struct MoviesListView {
    
    @State private var movieToShow: PopularMovie?
    @ObservedObject private var viewStore: ViewStore<MoviesListState, MoviesListAction>
    
    private let store: Store<MoviesListState, MoviesListAction>
    
    init(store: Store<MoviesListState, MoviesListAction>) {
        self.store = store
        viewStore = ViewStore(store)
        
        let navbarAppearance = UINavigationBarAppearance()
        navbarAppearance.titleTextAttributes = [.foregroundColor: Theme.default.colors.text.title.uiColor]
        navbarAppearance.backgroundColor = Theme.default.colors.background.uiColor
        UINavigationBar.appearance().standardAppearance = navbarAppearance
        UINavigationBar.appearance().compactAppearance = navbarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navbarAppearance
    }
}

// MARK: - View
extension MoviesListView: View {
    
    var body: some View {
        popularMoviesList
            .background(Theme.default.colors.background)
            .alert(store.scope(state: \.errorAlert), dismiss: .alertDismissed)
            .navigationTitle(L10n.MoviesList.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(
                item: viewStore.binding(
                    get: \.selectedMovie,
                    send: .dismissMovieDetails
                ),
                content: { _ in
                    IfLetStore(
                        store.scope(state: \.selectedMovie, action: MoviesListAction.movieDetails),
                        then: MovieDetailsView.init(store:)
                    )
                }
            )
            .onAppear {
                viewStore.send(.loadNextPage)
            }
    }
}

// MARK: - Components
private extension MoviesListView {
    
    var popularMoviesList: some View {
        PagedList(
            viewStore.popularMovies,
            hasLoadedLastPage: !viewStore.isLoadingMovies,
            nextPage: {
                viewStore.send(.loadNextPage)
            },
            content: { movie in
                popularMovieRow(movie: movie)
            }
        )
    }
    
    func popularMovieRow(movie: PopularMovie) -> some View {
        PopularMovieRow(movie: movie)
            .onTapGesture {
                viewStore.send(.selectMovie(movie))
            }
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView(store: .init(initialState: .init(), reducer: moviesListReducer, environment: .mock))
    }
}
