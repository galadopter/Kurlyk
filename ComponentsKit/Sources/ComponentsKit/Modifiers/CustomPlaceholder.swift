//
//  File.swift
//  
//
//  Created by Yan Schneider on 13/04/2022.
//

import SwiftUI
import DesignSystem

extension View {
    
    /// Adds custom placeholder view to a TextField.
    ///
    /// - Parameter when: Boolean value which controls visibility of placehodler. Common choice is `text.isEmpty`.
    /// - Parameter alignment: Alignment of placeholder. By default it's `leading`.
    /// - Parameter placeholder: Builder closure for custom placeholder view.
    ///
    /// Don't forget to initialize TextField with empty placeholder value and then call this modifier.
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    /// Adds placeholder text to a TextField.
    ///
    /// - Parameter text: Placeholder text.
    /// - Parameter when: Boolean value which controls visibility of placehodler. Common choice is `text.isEmpty`.
    /// - Parameter color: Foreground color of placeholder. By default is `text.secondary`.
    /// - Parameter alignment: Alignment of placeholder. By default it's `leading`.
    ///
    /// Don't forget to initialize TextField with empty placeholder value and then call this modifier.
    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        color: DesignSystem.Color = Theme.default.colors.text.placeholder,
        alignment: Alignment = .leading
    ) -> some View {
        placeholder(when: shouldShow, alignment: alignment) {
            Text(text).foregroundColor(color)
        }
    }
}
