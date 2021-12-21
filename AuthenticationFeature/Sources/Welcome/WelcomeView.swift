//
//  WelcomeView.swift
//  Kurlyk
//
//  Created by Yan Schneider on 15.11.21.
//

import SwiftUI
import UIComponents
import ComposableArchitecture

struct WelcomeView: View {
    
    let store: Store<WelcomeState, WelcomeAction>
    
    @ObservedObject private var viewStore: ViewStore<ViewState, WelcomeAction>
    
    struct ViewState: Equatable {
        var shouldShowCreateUser = false
        
        init(state: WelcomeState) {
            if case .createUser = state {
                shouldShowCreateUser = true
            }
        }
    }
    
    init(store: Store<WelcomeState, WelcomeAction>) {
        self.store = store
        self.viewStore = ViewStore(store.scope(state: ViewState.init(state:)))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Welcome to Kurlyk")
                    .font(.title)
                    .padding(.top, 36)
                Spacer()
                login
                createUser
                createUserNavigation
            }
        }
    }
    
    var login: some View {
        FilledButton(title: "Login") {
            viewStore.send(.login)
        }
            .padding(.horizontal, 16)
    }
    
    var createUser: some View {
        FilledButton(title: "Create user", backgroundColor: .blue) {
            viewStore.send(.createUserTapped)
        }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
    }
    
    var createUserNavigation: some View {
        NavigationLink(
            destination: IfLetStore(
                store.scope(state: /WelcomeState.createUser, action: WelcomeAction.createUser),
                then: CreateUserView.init(store:)
            ),
            isActive: viewStore.binding(get: \.shouldShowCreateUser, send: .revertState),
            label: EmptyView.init
        )
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(
            store: .init(
                initialState: .init(),
                reducer: welcomeReducer,
                environment: .mock
            )
        )
    }
}
