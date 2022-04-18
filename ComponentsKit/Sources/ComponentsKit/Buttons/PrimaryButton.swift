//
//  PrimaryButton.swift
//  Kurlyk
//
//  Created by Yan Schneider on 16.11.21.
//

import SwiftUI
import DesignSystem

/// Primary button in UI. It has filled background and rounded corners.
///
/// Usually it's used to mark primary actions in view.
/// It's better to not use a lot of primary button in one view.
public struct PrimaryButton {
    let title: String
    let showLoading: Bool
    let action: () -> ()
    
    /// Initializer for primary button
    ///
    /// - Parameter title: Title of the button
    /// - Parameter showLoading: Controls loader visibility. 
    /// - Parameter action: Action that is performed on button press
    public init(
        title: String,
        showLoading: Bool = false,
        action: @escaping () -> ()
    ) {
        self.title = title
        self.showLoading = showLoading
        self.action = action
    }
}

// MARK: - View
extension PrimaryButton: View {
    
    public var body: some View {
        Button(title, action: action)
            .buttonStyle(Theme.default.buttonStyles.primary)
            .loader(isLoading: showLoading)
    }
}

struct PrimaryButtonButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "Create post", action: {})
    }
}
