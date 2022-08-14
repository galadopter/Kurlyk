//
//  LoginView.swift
//  AuthenticationFeature
//
//  Created by Yan Schneider on 21.12.21.
//

import SwiftUI
import DesignSystem
import ComponentsKit
import ComposableArchitecture

struct LoginView {
    
    @FocusState private var focusedField: FocusField?
    @ObservedObject private var viewStore: ViewStore<LoginState, LoginAction>
    
    let store: Store<LoginState, LoginAction>
    
    private enum FocusField: Hashable {
        case email, password
    }
    
    init(store: Store<LoginState, LoginAction>) {
        self.store = store
        viewStore = ViewStore(store)
    }
}

// MARK: - View
extension LoginView: View {

    var body: some View {
        VStack {
            emailField
            passwordField
            Spacer()
            loginButton
        }
            .alert(store.scope(state: \.errorAlert), dismiss: .alertDismissed)
            .background(Theme.default.colors.background)
    }
}

// MARK: - Components
private extension LoginView {
    
    var emailField: some View {
        NamedField(
            title: L10n.Login.Fields.Email.title,
            prompt: L10n.Login.Fields.Email.prompt,
            text: viewStore.binding(\.$email)
        )
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .focused($focusedField, equals: .email)
            .onSubmit {
                focusedField = .password
            }
    }
    
    var passwordField: some View {
        PasswordField(
            title: L10n.Login.Fields.Password.title,
            prompt: L10n.Login.Fields.Password.prompt,
            text: viewStore.binding(\.$password)
        )
            .focused($focusedField, equals: .password)
            .onSubmit {
                viewStore.send(.login)
            }
    }
    
    var loginButton: some View {
        PrimaryButton(
            title: L10n.Login.Buttons.login,
            showLoading: viewStore.isLoading
        ) {
            viewStore.send(.login)
        }.disabled(!viewStore.isFormValid)
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: .init(
                initialState: .init(),
                reducer: loginReducer,
                environment: .mock
            )
        )
    }
}
