//
//  MoviesListFeatureView.swift
//  
//
//  Created by Yan Schneider on 19/04/2022.
//

import SwiftUI
import ComposableArchitecture

public struct MoviesListFeatureView: View {
    
    let store: Store<MoviesListFeatureState, MoviesListFeatureAction>
    
    public init(store: Store<MoviesListFeatureState, MoviesListFeatureAction>) {
        self.store = store
    }
    
    public var body: some View {
        IfLetStore(
            store.scope(
                state: /MoviesListFeatureState.moviesList,
                action: MoviesListFeatureAction.moviesList
            ),
            then: MoviesListView.init(store:)
        )
    }
}

struct MoviesListFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListFeatureView(store: .init(initialState: .init(), reducer: moviesListFeatureReducer, environment: .mock))
    }
}
