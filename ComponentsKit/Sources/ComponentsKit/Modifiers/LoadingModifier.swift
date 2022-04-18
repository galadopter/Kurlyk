//
//  File.swift
//  
//
//  Created by Yan Schnaider on 27/03/2022.
//

import SwiftUI

struct LoadingViewModifier: ViewModifier {
    
    var isLoading: Bool
    var showBackground: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            if isLoading {
                content.opacity(0.4)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
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
    /// - Parameter showBackground: Sets background visibility. Default is `true`.
    public func loader(isLoading: Bool, showBackground: Bool = true) -> some View {
        modifier(LoadingViewModifier(isLoading: isLoading, showBackground: showBackground))
    }
}
