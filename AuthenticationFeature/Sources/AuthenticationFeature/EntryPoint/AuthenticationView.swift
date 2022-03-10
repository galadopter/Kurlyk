//
//  AuthenticationView.swift
//  AuthenticationFeature
//
//  Created by Yan Schneider on 26.11.21.
//

import SwiftUI
import ComposableArchitecture

public struct AuthenticationView: View {
    
    let store: Store<AuthenticationState, AuthenticationAction>
    
    public init(store: Store<AuthenticationState, AuthenticationAction>) {
        self.store = store
    }
    
    public var body: some View {
        IfLetStore(
            store.scope(
                state: /AuthenticationState.welcome,
                action: AuthenticationAction.welcome
            ),
            then: WelcomeView.init(store:)
        )
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(store: .init(initialState: .init(), reducer: authenticationReducer, environment: .mock))
    }
}
