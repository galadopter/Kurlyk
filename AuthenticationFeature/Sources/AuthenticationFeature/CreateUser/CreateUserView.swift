//
//  CreateUserView.swift
//  Kurlyk
//
//  Created by Yan Schneider on 18.11.21.
//

import SwiftUI
import ComponentsKit
import DesignSystem
import ComposableArchitecture

struct CreateUserView {
    
    @FocusState private var focusedField: FocusField?
    @ObservedObject private var viewStore: ViewStore<CreateUserState, CreateUserAction>
    
    private let createUserButtonID = "createUserButton"
    
    let store: Store<CreateUserState, CreateUserAction>
    
    private enum FocusField: Hashable {
        case name, email, password, confirmPassword
    }
    
    init(store: Store<CreateUserState, CreateUserAction>) {
        self.store = store
        viewStore = ViewStore(store)
    }
}

// MARK: - View
extension CreateUserView: View {
    
    var body: some View {
        ScrollView {
            VStack {
                nameField
                emailField
                passwordField
                confirmPasswordField
                Spacer()
                createUserButton
                navigation
            }
        }
            .navigationBarTitleDisplayMode(.inline)
            .alert(store.scope(state: \.errorAlert), dismiss: .alertDismissed)
            .background(Theme.default.colors.background)
    }
}

// MARK:  - Components
private extension CreateUserView {
    
    var nameField: some View {
        NamedField(title: "Name", prompt: "Enter your name here",
                   text: viewStore.binding(\.$name))
            .focused($focusedField, equals: .name)
            .onSubmit {
                focusedField = .email
            }
    }
    
    var emailField: some View {
        NamedField(title: "Email", prompt: "Enter your email here",
                   text: viewStore.binding(\.$email))
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .focused($focusedField, equals: .email)
            .onSubmit {
                focusedField = .password
            }
    }
    
    var passwordField: some View {
        PasswordField(title: "Password", prompt: "Enter your password here",
                      text: viewStore.binding(\.$password))
            .focused($focusedField, equals: .password)
            .onSubmit {
                focusedField = .confirmPassword
            }
    }
    
    var confirmPasswordField: some View {
        PasswordField(title: "Confirm Password", prompt: "Confirm your password here",
                      text: viewStore.binding(\.$confirmPassword))
            .focused($focusedField, equals: .confirmPassword)
            .onSubmit {
                viewStore.send(.createUser)
            }
    }
    
    var createUserButton: some View {
        PrimaryButton(
            title: "Create user",
            showLoading: viewStore.isCreatingUser
        ) {
            viewStore.send(.createUser)
        }.disabled(!viewStore.isFormValid)
        .id(createUserButtonID)
        .padding()
    }
}

// MARK: - Navigation
extension CreateUserView {
    
    var navigation: some View {
        NavigationLink(
            destination: UserCreationSucceedView(),
            isActive: viewStore.binding(\.$hasCreatedUser),
            label: EmptyView.init
        )
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView(
            store: .init(
                initialState: .init(),
                reducer: createUserReducer,
                environment: .mock
            )
        )
    }
}
