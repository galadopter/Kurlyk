//
//  WelcomeView.swift
//  Kurlyk
//
//  Created by Yan Schneider on 15.11.21.
//

import SwiftUI
import DesignSystem
import ComponentsKit
import ComposableArchitecture

struct WelcomeView {
    
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
}

// MARK: - View
extension WelcomeView: View {
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.default.sizes.lg) {
                welcomeTitle
                Spacer()
                login
                createUser
                navigation
            }
            .background(Theme.default.colors.background)
        }.accentColor(Theme.default.colors.navigation)
    }
}

// MARK: - Components
private extension WelcomeView {
    
    var welcomeTitle: some View {
        Text("Welcome to Kurlyk")
            .foregroundColor(Theme.default.colors.text.secondary)
            .font(Theme.default.fonts.defaultFont(.title, .bold))
            .padding(.top, Theme.default.sizes.xl)
    }
    
    var login: some View {
        PrimaryButton(title: "Login") {
            viewStore.send(.loginTapped)
        }
        .padding(.horizontal, Theme.default.sizes.md)
    }
    
    var createUser: some View {
        SecondaryButton(title: "Create user") {
            viewStore.send(.createUserTapped)
        }
            .padding(.horizontal, Theme.default.sizes.md)
            .padding(.bottom, Theme.default.sizes.lg)
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
