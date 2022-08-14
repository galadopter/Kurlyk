//
//  AppAction.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import Foundation
import AuthenticationFeature
import MoviesListFeature

enum AppAction: Equatable {
    case authentication(AuthenticationAction)
    case moviesList(MoviesListFeatureAction)
}
