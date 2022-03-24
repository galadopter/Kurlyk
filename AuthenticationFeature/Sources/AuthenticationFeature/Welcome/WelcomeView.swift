//
//  WelcomeView.swift
//  Kurlyk
//
//  Created by Yan Schneider on 15.11.21.
//

import SwiftUI
import ComponentsKit
import ComposableArchitecture

struct WelcomeView: View {
    
    let store: Store<WelcomeState, WelcomeAction>
    
    @ObservedObject private var viewStore: ViewStore<ViewState, WelcomeAction>
    
    struct ViewState: Equatable {
        var shouldNavigate = false
        
        init(state: WelcomeState) {
            switch state {
            case .createUser, .login:
                shouldNavigate = true
            default: break
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
                navigation
            }
        }
    }
    
    var login: some View {
        PrimaryButton(title: "Login") {
            viewStore.send(.loginTapped)
        }
            .padding(.horizontal, 16)
    }
    
    var createUser: some View {
        SecondaryButton(title: "Create user") {
            viewStore.send(.createUserTapped)
        }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
    }
}

// MARK: - Navigation
private extension WelcomeView {
    
    var navigation: some View {
        NavigationLink(
            destination: SwitchStore(store) {
                CaseLet(
                    state: /WelcomeState.login,
                    action: WelcomeAction.login,
                    then: LoginView.init(store:)
                )
                
                CaseLet(
                    state: /WelcomeState.createUser,
                    action: WelcomeAction.createUser,
                    then: CreateUserView.init(store:)
                )
                
                Default(content: EmptyView.init)
            },
            isActive: viewStore.binding(get: \.shouldNavigate, send: .revertState),
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
