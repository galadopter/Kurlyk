//
//  Pagination.swift
//  Domain
//
//  Created by Yan Schnaider on 28/12/2021.
//

import Foundation

/// Gives ability to count pages and check for page overflow.
///
/// It's used together with `PaginationUseCase`.
public struct PaginationCounter: Equatable {
    public var currentPage = 1
    private var totalPages: Int?
    
    public var isLastPage: Bool {
        guard let totalPages = totalPages else { return false }
        return currentPage > totalPages
    }
    
    public init() {}
    
    public mutating func increment() {
        currentPage += 1
    }
    
    public mutating func set(totalPages: Int) {
        self.totalPages = totalPages
    }
}
