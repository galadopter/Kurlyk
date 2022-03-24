//
//  SecondaryButton.swift
//  
//
//  Created by Yan Schneider on 24.03.22.
//

import SwiftUI
import DesignSystem

/// Secondary button in UI. It has empty background with border and rounded corners.
///
/// Usually it's used to mark secondary actions in view.
/// It's possible to use it more than once in one screen.
public struct SecondaryButton {
    let title: String
    let action: () -> ()
    
    /// Initializer for secondary button
    ///
    /// - Parameter title: Title of the button
    /// - Parameter action: Action that is performed on button press
    public init(
        title: String,
        action: @escaping () -> ()
    ) {
        self.title = title
        self.action = action
    }
}

// MARK: - View
extension SecondaryButton: View {
    
    public var body: some View {
        Button(title, action: action)
            .buttonStyle(Theme.default.buttonStyles.secondary)
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton(title: "Change locale", action: {
            Theme.default.update(keyPath: \.sizes.xxs, withValue: 16)
        })
    }
}
