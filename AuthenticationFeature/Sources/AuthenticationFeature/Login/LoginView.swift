//
//  LoginView.swift
//  AuthenticationFeature
//
//  Created by Yan Schneider on 21.12.21.
//

import SwiftUI
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
    }
}

// MARK: - Components
private extension LoginView {
    
    var emailField: some View {
        NamedField(title: "Email", prompt: "test@example.com",
                   text: viewStore.binding(\.$email))
            .focused($focusedField, equals: .email)
            .onSubmit {
                focusedField = .password
            }
    }
    
    var passwordField: some View {
        NamedField(title: "Password", prompt: "Enter your password here",
                   text: viewStore.binding(\.$password))
            .focused($focusedField, equals: .password)
            .onSubmit {
                print("S")
            }
    }
    
    var loginButton: some View {
        PrimaryButton(title: "Login") {
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
