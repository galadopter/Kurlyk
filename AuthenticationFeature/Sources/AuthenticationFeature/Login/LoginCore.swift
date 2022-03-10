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
    
    var isFormValid = false
    var errorAlert: AlertState<LoginAction>?
}

public enum LoginAction: BindableAction, Equatable {
    case binding(BindingAction<LoginState>)
    case login
    case alertDismissed
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
        return .none
        
    case .alertDismissed:
        return .none
    }
}.binding()
