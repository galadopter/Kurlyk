//
//  AppView.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import SwiftUI
import ComposableArchitecture
import AuthenticationFeature
import MoviesListFeature

struct AppView: View {
    
    let store: Store<AppState, AppAction>
    
    var body: some View {
        SwitchStore(store) {
            CaseLet(
                state: /AppState.authentication,
                action: AppAction.authentication,
                then: AuthenticationFeature.AuthenticationView.init(store:)
            )
            CaseLet(
                state: /AppState.moviesList,
                action: AppAction.moviesList,
                then: MoviesListFeature.MoviesListFeatureView.init(store:)
            )
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: .init(
                initialState: .authentication(.init()),
                reducer: appReducer,
                environment: .live
            )
        )
    }
}
