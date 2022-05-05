//
//  File.swift
//  
//
//  Created by Yan Schnaider on 27/03/2022.
//

import SwiftUI
import DesignSystem

struct LoadingViewModifier: ViewModifier {
    
    var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                content.opacity(0.4)
                ProgressView()
                    .tint(Theme.default.colors.accessory)
            } else {
                content
            }
        }
    }
}

// MARK: - View extension
extension View {
    
    /// Shows a loading indicator on top of the view.
    ///
    /// - Parameter isLoading: Sets loading indicator visibility.
    public func loader(isLoading: Bool) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading))
    }
}
