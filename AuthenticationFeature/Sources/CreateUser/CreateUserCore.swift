//
//  CreateUserCore.swift
//  Kurlyk
//
//  Created by Yan Schneider on 18.11.21.
//

import Domain
import Combine
import ComposableArchitecture

public struct CreateUserState: Equatable {
    @BindableState var name = ""
    @BindableState var email = ""
    @BindableState var password = ""
    @BindableState var confirmPassword = ""
    @BindableState var hasCreatedUser = false
    
    var isFormValid = false
    var isCreatingUser = false
    var errorAlert: AlertState<CreateUserAction>?
}

public enum CreateUserAction: BindableAction, Equatable {
    case binding(BindingAction<CreateUserState>)
    case alertDismissed
    case createUser
    case userCreationResult(Result<None, DomainError>)
}

private let createUserValidator = ValidateEntityUseCase<CreateUserState> { user in
    HasMinimalLengthRule(value: user.name, length: 2)
    IsEmailRule(email: user.email)
    HasMinimalLengthRule(value: user.password, length: 8)
    AreEqualRule(first: user.password, second: user.confirmPassword)
}

private func errorAlert<Action>(message: String) -> AlertState<Action> {
    return .init(title: TextState("Error"), message: TextState(message))
}

var createUserReducer = Reducer<CreateUserState, CreateUserAction, AuthenticationEnvironment> { state, action, environment in
    switch action {
    case .binding:
        state.isFormValid = shouldSucceed {
            try createUserValidator.execute(input: state)
        }
        return .none
        
    case .alertDismissed:
        state.errorAlert = nil
        return .none
        
    case .createUser:
        if !state.isFormValid {
            state.errorAlert = errorAlert(message: "Check your data")
            return .none
        }
        
        let userCreator = CreateUserUseCase(gateway: environment.createUserGateway)
        let user = User.Create(email: state.email, password: state.password, name: state.name, biography: "")
        state.isCreatingUser = true
        
        return Effect<Void, DomainError>.task {
            try await userCreator.execute(input: user)
        }
        .receive(on: environment.mainQueue)
        .mapToNone()
        .catchToEffect(CreateUserAction.userCreationResult)
    
    case .userCreationResult(let result):
        state.isCreatingUser = false
        
        switch result {
        case .success:
            state.hasCreatedUser = true
        case .failure:
            state.errorAlert = errorAlert(message: "User creation failed!")
        }
        return .none
    }
}.binding()
