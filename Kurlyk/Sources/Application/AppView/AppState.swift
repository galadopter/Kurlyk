//
//  AppState.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import Foundation
import AuthenticationFeature

enum AppState: Equatable {
    case authentication(AuthenticationState)
    
    init() { self = .authentication(.init()) }
}
