//
//  MoviesListView.swift
//  
//
//  Created by Yan Schneider on 19/04/2022.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct MoviesListView {
    
    @ObservedObject private var viewStore: ViewStore<MoviesListState, MoviesListAction>
    
    private let store: Store<MoviesListState, MoviesListAction>
    
    init(store: Store<MoviesListState, MoviesListAction>) {
        self.store = store
        viewStore = ViewStore(store)
    }
}

// MARK: - View
extension MoviesListView: View {
    
    var body: some View {
        NavigationView {
            popularMoviesList
        }.background(Theme.default.colors.background)
        .onAppear {
            viewStore.send(.loadNextPage)
        }
    }
}

// MARK: - Components
private extension MoviesListView {
    
    var popularMoviesList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewStore.popularMovies.indices, id: \.self) { index in
                    popularMoviesRow(viewStore.popularMovies[index])
                        .onAppear {
                            guard shouldLoadNextPage(currentIndex: index, collection: viewStore.popularMovies) else { return }
                            viewStore.send(.loadNextPage)
                        }
                    bottomProgressView(currentIndex: index)
                }
            }
        }
    }
    
    func popularMoviesRow(_ movie: PopularMovie) -> some View {
        PopularMovieRow(movie: movie)
    }
    
    @ViewBuilder
    func bottomProgressView(currentIndex: Int) -> some View {
        if viewStore.isLoadingMovies && currentIndex == viewStore.popularMovies.endIndex - 1 {
            HStack {
                ProgressView()
                Text("Loading more...")
            }
        }
    }
}

// MARK: - Helpers
private extension MoviesListView {
    
    enum Constants {
        static let loadItemsThreshold = 4
    }
    
    func shouldLoadNextPage<T>(currentIndex: Int, collection: Array<T>) -> Bool {
        collection.distance(from: currentIndex, to: collection.endIndex) == Constants.loadItemsThreshold
    }
}

struct MoviesListView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView(store: .init(initialState: .init(), reducer: moviesListReducer, environment: .mock))
    }
}
