//
//  File.swift
//  
//
//  Created by Yan Schnaider on 06/04/2022.
//

import SwiftUI
import DesignSystem

/// Secure field with large title on top. It doesn't have any background.
///
/// It's should be used to gather passwords.
public struct PasswordField: View {
    
    let title: String
    let prompt: String
    @Binding var text: String
    
    ///  Initializer for password field
    ///
    ///  - Parameter title: Field's title, displayed on top with a `title` font style
    ///  - Parameter prompt: Placeholder for the textfield
    ///  - Parameter text: Text binding
    public init(title: String, prompt: String, text: Binding<String>) {
        self.title = title
        self.prompt = prompt
        self._text = text
    }

    public var body: some View {
        VStack(spacing: Theme.default.sizes.sm) {
            HStack {
                Text(title)
                    .font(Theme.default.fonts.defaultFont(.title, .medium))
                Spacer()
            }
                .padding(.horizontal, Theme.default.sizes.md)
                .padding(.top, Theme.default.sizes.sm)
            
            SecureField(prompt, text: $text)
                .frame(height: 40)
                .font(Theme.default.fonts.defaultFont(.body, .medium))
                .padding(.horizontal, Theme.default.sizes.md)
        }
    }
}

struct PasswordField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordField(title: "Password", prompt: "•••••••••", text: .constant(""))
    }
}
