//
//  FavoriteMoviesListView.swift
//  
//
//  Created by Yan Schneider on 09/08/2022.
//

import SwiftUI
import Domain
import DesignSystem
import ComposableArchitecture

struct FavoriteMoviesListView: View {
    
    @ObservedObject private var viewStore: ViewStore<FavoriteMoviesListState, FavoriteMoviesListAction>
    
    let store: Store<FavoriteMoviesListState, FavoriteMoviesListAction>
    
    init(store: Store<FavoriteMoviesListState, FavoriteMoviesListAction>) {
        self.store = store
        viewStore = ViewStore(store)
    }
    
    var body: some View {
        list
            .background(Theme.default.colors.background)
            .navigationTitle(L10n.FavoriteMovies.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { viewStore.send(.loadFavoriteMovies) }
    }
}

// MARK: - Components
private extension FavoriteMoviesListView {
    
    var list: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewStore.favoriteMovies, id: \.id) { movie in
                    FavoriteMovieRow(movie: movie)
                }.animation(.default, value: viewStore.favoriteMovies)
            }
        }
    }
}

struct FavoriteMoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMoviesListView(store: .init(initialState: .init(), reducer: favoriteMoviesReducer, environment: .mock))
    }
}
