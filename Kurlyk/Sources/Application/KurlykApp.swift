//
//  KurlykApp.swift
//  Kurlyk
//
//  Created by Yan Schneider on 15.11.21.
//

import SwiftUI
import ComposableArchitecture

@main
struct KurlykApp: App {
    
    var body: some Scene {
        WindowGroup {
            AppView(
                store: .init(
                    initialState: .init(),
                    reducer: appReducer,
                    environment: .live
                )
            )
        }
    }
}
