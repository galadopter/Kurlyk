//
//  PaginationUseCase.swift
//  Domain
//
//  Created by Yan Schnaider on 28/12/2021.
//

import Foundation

/// Performs pagination for a given async task.
///
/// It doesn't store any metadata, so it's intended to happen on a caller side.
public struct PaginationUseCase<T: HasTotalPages> {
    private let task: PaginationUseCase.Task
    
    public typealias Task = (PageIndex) async throws -> T
    public typealias PageIndex = Int
    
    public enum PaginationError: Error, Equatable {
        case reachedTheLimit
    }
    
    public init(paginationTask: @escaping PaginationUseCase.Task) {
        self.task = paginationTask
    }
}

extension PaginationUseCase: AsyncThrowableUseCaseType {
    
    /// Use case's output.
    public struct Output {
        /// Modified pagination object. If task completed successfuly, new pagination will contain incremented page number.
        public let pagination: Pagination
        /// Result for a given page.
        public let result: T
    }
    
    /// Performs a pagination task.
    ///
    /// - Parameter input: Current state of `Pagination` metadata. It's used to determine current page.
    ///
    /// - Throws: It throws `PaginationError.reachedTheLimit` if pagination is already on it's last page.
    ///
    /// - Returns: A modified `Pagination` metadata and a result of a task.
    public func execute(input: Pagination) async throws -> Output {
        var pagination = input
        guard !pagination.isLastPage else {
            throw PaginationError.reachedTheLimit
        }
        
        let result = try await task(pagination.currentPage)
        
        pagination.increment()
        pagination.set(totalPages: result.totalPages)
        
        return .init(pagination: pagination, result: result)
    }
}
