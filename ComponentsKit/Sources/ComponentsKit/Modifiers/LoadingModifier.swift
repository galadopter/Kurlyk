//
//  File.swift
//  
//
//  Created by Yan Schnaider on 27/03/2022.
//

import SwiftUI

struct LoadingViewModifier: ViewModifier {
    
    var isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                Color.white
                    .opacity(0.6)
                    .blur(radius: 10)
                ProgressView()
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
