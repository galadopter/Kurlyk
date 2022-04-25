//
//  Pagination.swift
//  Domain
//
//  Created by Yan Schnaider on 28/12/2021.
//

import Foundation

public protocol Pagination {
    var currentPage: Int { get }
    var isLastPage: Bool { get }
    mutating func increment()
    mutating func set(totalPages: Int)
}

public struct PaginationCounter: Pagination {
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
