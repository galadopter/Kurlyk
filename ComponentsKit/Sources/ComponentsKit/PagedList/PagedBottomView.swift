//
//  PagedBottomView.swift
//  
//
//  Created by Yan Schneider on 01/05/2022.
//

import SwiftUI
import DesignSystem

/// Default bottom view for `PagedList`.
///
/// Consists of `ProgressView` horizontally aligned with `Text`.
public struct PagedBottomView {
    
    let text: String
    
    /// Creates an instance of `PagedBottomView` with given text.
    ///
    /// - Parameter text: Text that is displayed together with `ProgressView`.
    public init(text: String = "Loading more...") {
        self.text = text
    }
}

// MARK: - View
extension PagedBottomView: View {
    
    public var body: some View {
        HStack(spacing: Theme.default.sizes.md) {
            ProgressView()
            Text(text)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PagedBottomView()
    }
}
