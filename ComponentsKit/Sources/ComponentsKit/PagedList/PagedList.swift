//
//  PagedList.swift
//  
//
//  Created by Yan Schneider on 29/04/2022.
//

import SwiftUI

/// List with pagination support.
///
/// Use it to show list of continiously updating data. You can also provide a custom bottom loader view.
public struct PagedList<Data, Content: View, BottomView: View> where Data: RandomAccessCollection, Data.Index: BinaryInteger {
    let data: Data
    let hasLoadedLastPage: Bool
    let nextPageTrigger: Data.Index
    let nextPage: () -> Void
    let bottomLoader: () -> BottomView
    let content: (Data.Element) -> Content
    
    
    /// Initializer for `PagedList`.
    ///
    /// - Parameter data: Collection of loaded Data, which needs to be presented.
    /// - Parameter hasLoadedLastPage: Flag which controls the bottom view visibility. Default: `false`.
    /// - Parameter nextPageTrigger: Page threshold, used to determine how soon the view should trigger `nextPage` action. Default: `4`.
    /// - Parameter nextPage: Action to start loading next page. It is trigger when data.endIndex - nextPageTrigger cell is shown.
    /// - Parameter bottomLoader: Loader view which is shown at the bottom of list.
    /// - Parameter content: Content of list.
    public init(
        _ data: Data,
        hasLoadedLastPage: Bool = false,
        nextPageTrigger: Data.Index = 4,
        nextPage: @escaping () -> Void,
        @ViewBuilder bottomLoader: @escaping () -> BottomView,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.hasLoadedLastPage = hasLoadedLastPage
        self.nextPageTrigger = nextPageTrigger
        self.nextPage = nextPage
        self.bottomLoader = bottomLoader
        self.content = content
    }
}

// MARK: - Default Bottom View
extension PagedList where BottomView == PagedBottomView {
    
    /// Initializer for `PagedList`.
    ///
    /// Bottom view loader is initialized as `PagedBottomView`.
    ///
    /// - Parameter data: Collection of loaded Data, which needs to be presented.
    /// - Parameter hasLoadedLastPage: Flag which controls the bottom view visibility. Default: `false`.
    /// - Parameter nextPageTrigger: Page threshold, used to determine how soon the view should trigger `nextPage` action. Default: `4`.
    /// - Parameter nextPage: Action to start loading next page. It is trigger when data.endIndex - nextPageTrigger cell is shown.
    /// - Parameter content: Content of list.
    public init(
        _ data: Data,
        hasLoadedLastPage: Bool = false,
        nextPageTrigger: Data.Index = 4,
        nextPage: @escaping () -> Void,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.hasLoadedLastPage = hasLoadedLastPage
        self.nextPageTrigger = nextPageTrigger
        self.nextPage = nextPage
        self.bottomLoader = { PagedBottomView() }
        self.content = content
    }
}

// MARK: - View
extension PagedList: View {
    
    public var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(data.indices, id: \.self) { index in
                    content(data[index])
                        .onAppear {
                            guard shouldLoadNextPage(currentIndex: index) else { return }
                            nextPage()
                        }
                    if shouldShowBottomLoader(currentIndex: index) {
                        bottomLoader()
                    }
                }
            }
        }
    }
}

// MARK: - Helpers
private extension PagedList {
    
    func shouldLoadNextPage(currentIndex: Data.Index) -> Bool {
        data.distance(from: currentIndex, to: data.endIndex) == nextPageTrigger
    }
    
    func shouldShowBottomLoader(currentIndex: Data.Index) -> Bool {
        !hasLoadedLastPage && data.distance(from: currentIndex, to: data.endIndex) == 1
    }
}

struct PagedList_Previews: PreviewProvider {
    static var previews: some View {
        PagedList([1, 2, 3], nextPage: {  }, content: {
            Text(String($0))
        })
    }
}
