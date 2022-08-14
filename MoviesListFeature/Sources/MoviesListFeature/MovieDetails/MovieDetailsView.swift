//
//  MovieDetailsView.swift
//  
//
//  Created by Yan Schneider on 04/05/2022.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct MovieDetailsView {
    
    @ObservedObject private var viewStore: ViewStore<MovieDetailsState, MovieDetailsAction>
    
    private let store: Store<MovieDetailsState, MovieDetailsAction>
    
    init(store: Store<MovieDetailsState, MovieDetailsAction>) {
        self.store = store
        viewStore = ViewStore(store)
    }
}

// MARK: - View
extension MovieDetailsView: View {
    
    var body: some View {
        ZStack {
            background
            if let movie = viewStore.movieDetails {
                LoadedMovieDetailsView(
                    movie: movie,
                    isPerformingLoadingAction: viewStore.isPerformingFavoriteAction
                ) {
                    viewStore.send(.changeFavoriteStatus)
                }.animation(.default, value: viewStore.isPerformingFavoriteAction)
            } else {
                loader
            }
        }.onAppear {
            viewStore.send(.loadDetails)
        }
    }
}

// MARK: - Components
private extension MovieDetailsView {
    
    var background: some View {
        Theme.default.colors.background.swiftUIColor
            .edgesIgnoringSafeArea(.all)
    }
    
    var loader: some View {
        ProgressView()
            .tint(Theme.default.colors.accessory)
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(store: .init(initialState: .init(movieID: .init(id: "1")), reducer: movieDetailsReducer, environment: .mock))
    }
}
