//
//  MoviesListFeatureView.swift
//  
//
//  Created by Yan Schneider on 19/04/2022.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct MoviesListFeatureView {
    
    let store: Store<MoviesListFeatureState, MoviesListFeatureAction>
    
    public init(store: Store<MoviesListFeatureState, MoviesListFeatureAction>) {
        self.store = store
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = Theme.default.colors.background.uiColor
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - View
extension MoviesListFeatureView: View {
    
    public var body: some View {
        WithViewStore(store) { viewStore in
            TabView(selection: viewStore.binding(\.$currentTab)) {
                moviesList
                
                favoriteMovies
            }
            .accentColor(Theme.default.colors.primary)
        }
    }
}

// MARK: - Tabs
private extension MoviesListFeatureView {
    
    var moviesList: some View {
        NavigationView {
            MoviesListView(store: store.scope(
                state: \MoviesListFeatureState.moviesList,
                action: MoviesListFeatureAction.moviesList
            ))
        }
        .tabItem {
            moviesListItem
        }
        .tag(TabViewPage.moviesList)
    }
    
    var favoriteMovies: some View {
        NavigationView {
            FavoriteMoviesListView(store: store.scope(
                state: \MoviesListFeatureState.favoriteMovies,
                action: MoviesListFeatureAction.favoriteMovies
            ))
        }
        .tabItem {
            favoriteMoviesItem
        }
        .tag(TabViewPage.favoriteMovies)
    }
}

// MARK: - Tab Items
private extension MoviesListFeatureView {
    
    var moviesListItem: some View {
        Label(L10n.TabView.MoviesList.title, systemImage: "list.bullet")
    }
    
    var favoriteMoviesItem: some View {
        Label(L10n.TabView.FavoriteMovies.title, systemImage: "star.fill")
    }
}

struct MoviesListFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListFeatureView(store: .init(initialState: .init(), reducer: moviesListFeatureReducer, environment: .mock))
    }
}
