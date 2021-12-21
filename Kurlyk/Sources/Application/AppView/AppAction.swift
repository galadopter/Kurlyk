//
//  AppAction.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import Foundation
import AuthenticationFeature

enum AppAction: Equatable {
    case authentication(AuthenticationAction)
}
