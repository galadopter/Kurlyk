//
//  LoginCore.swift
//  AuthenticationFeature
//
//  Created by Yan Schneider on 22.12.21.
//

import Foundation
import Domain
import ComponentsKit
import ComposableArchitecture

public struct LoginState: Equatable {
    @BindableState var email = ""
    @BindableState var password = ""
    @BindableState var hasLoggedIn = false
    
    var isFormValid = false
    var isLoading = false
    var errorAlert: AlertState<LoginAction>?
}

public enum LoginAction: BindableAction, Equatable {
    case binding(BindingAction<LoginState>)
    case login
    case alertDismissed
    case loginResult(Result<None, DomainError>)
}

private let loginValidator = ValidateEntityUseCase<LoginState> { user in
    IsEmailRule(email: user.email)
    HasMinimalLengthRule(value: user.password, length: 8)
}

var loginReducer = Reducer<LoginState, LoginAction, AuthenticationEnvironment> { state, action, environment in
    switch action {
    case .binding:
        state.isFormValid = shouldSucceed {
            try loginValidator.execute(input: state)
        }
        return .none
        
    case .login:
        if !state.isFormValid {
            state.errorAlert = errorAlert(message: "Check your data")
            return .none
        }
        
        let userGetter = GetUserUseCase(gateway: environment.getUserGateway)
        let user = User.Get(email: state.email, password: state.password)
        state.isLoading = true

        return Effect<Void, DomainError>.task {
            _ = try await userGetter.execute(input: user)
        }
        .receive(on: environment.mainQueue)
        .mapToNone()
        .catchToEffect(LoginAction.loginResult)
        
    case .loginResult(let result):
        state.isLoading = false
        
        switch result {
        case .success:
            state.hasLoggedIn = true
        case .failure:
            state.errorAlert = errorAlert(message: "Login failed!")
        }
        return .none
        
    case .alertDismissed:
        return .none
    }
}.binding()
