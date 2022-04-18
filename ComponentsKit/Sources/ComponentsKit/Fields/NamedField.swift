//
//  NamedField.swift
//  Kurlyk
//
//  Created by Yan Schneider on 23.11.21.
//

import SwiftUI
import DesignSystem

/// Field with large title on top. It doesn't have any background.
///
/// It's could be used to gather information from user in any type of forms.
public struct NamedField {
    let title: String
    let prompt: String
    @Binding var text: String
    
    ///  Initializer for named field
    ///
    ///  - Parameter title: Field's title, displayed on top with a `title` font style.
    ///  - Parameter prompt: Placeholder for the textfield.
    ///  - Parameter text: Text binding.
    public init(
        title: String,
        prompt: String,
        text: Binding<String>
    ) {
        self.title = title
        self.prompt = prompt
        self._text = text
    }
}

// MARK: - View
extension NamedField: View {
    
    public var body: some View {
        VStack(spacing: Theme.default.sizes.sm) {
            HStack {
                Text(title)
                    .foregroundColor(Theme.default.colors.text.secondary)
                    .font(Theme.default.fonts.defaultFont(.title, .medium))
                Spacer()
            }
                .padding(.horizontal, Theme.default.sizes.md)
                .padding(.top, Theme.default.sizes.sm)
            
            TextField("", text: $text)
                .placeholder(prompt, when: text.isEmpty)
                .frame(height: 40)
                .foregroundColor(Theme.default.colors.text.secondary)
                .font(Theme.default.fonts.defaultFont(.body, .medium))
                .padding(.horizontal, Theme.default.sizes.md)
        }
    }
}

struct NamedField_Previews: PreviewProvider {
    static var previews: some View {
        NamedField(title: "Name", prompt: "Enter name", text: .constant(""))
    }
}
