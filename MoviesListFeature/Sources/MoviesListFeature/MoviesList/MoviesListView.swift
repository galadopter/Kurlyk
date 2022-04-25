//
//  MoviesListView.swift
//  
//
//  Created by Yan Schneider on 19/04/2022.
//

import SwiftUI
import ComposableArchitecture

struct MoviesListView {
    
    let store: Store<MoviesListState, MoviesListAction>
    
    init(store: Store<MoviesListState, MoviesListAction>) {
        self.store = store
    }
}

// MARK: - View
extension MoviesListView: View {
    
    var body: some View {
        NavigationView {
            popularMoviesList
        }
    }
}

// MARK: - Components
extension MoviesListView {
    
    var popularMoviesList: some View {
        ScrollView {
            LazyVStack {
                ForEach((0..<12)) { _ in
                    popularMoviesRow
                }
            }
        }
    }
    
    var popularMoviesRow: some View {
        Text("Hello")
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView(store: .init(initialState: .init(), reducer: moviesListReducer, environment: .mock))
    }
}
