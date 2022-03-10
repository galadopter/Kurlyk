//
//  WelcomeCoreTests.swift
//  AuthenticationFeatureTests
//
//  Created by Yan Schneider on 21.12.21.
//

import XCTest
import ComposableArchitecture

@testable import AuthenticationFeature

class WelcomeCoreTests: XCTestCase {

    func testShouldNavigate_whenCreateUserButtonTapped() {
        let store = TestStore(
            initialState: WelcomeState(),
            reducer: welcomeReducer,
            environment: .test
        )
        
        store.send(.createUserTapped) {
            $0 = .createUser(.init())
        }
        store.send(.revertState) {
            $0 = .initial
        }
    }
}
