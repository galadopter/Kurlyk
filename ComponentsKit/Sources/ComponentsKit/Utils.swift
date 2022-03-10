//
//  Utils.swift
//  UIComponents
//
//  Created by Yan Schneider on 22.12.21.
//

import Foundation
import ComposableArchitecture

public func errorAlert<Action>(message: String) -> AlertState<Action> {
    return .init(title: TextState("Error"), message: TextState(message))
}
