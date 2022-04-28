//
//  PaginationUseCaseTests.swift
//  DomainTests
//
//  Created by Yan Schnaider on 29/12/2021.
//

import XCTest
import Nimble

@testable import Domain

class PaginationUseCaseTests: XCTestCase {

    func testShouldFinish_whenLimitHasReached() async throws {
        let totalPages = 3
        let pages = (1...totalPages).map { Mocks.moviesPage(page: $0, totalPages: totalPages) }
        var pagination = PaginationCounter()
        
        let sut = PaginationUseCase<MoviesPage>(paginationTask: { currentPage in
            pages[currentPage - 1]
        })
        
        for page in pages {
            let output = try await sut.execute(input: pagination)
            pagination = output.pagination
            expect(output.result).to(equal(page))
        }
    }
    
    func testShouldStopIncrementingPage_whenErrorOccured() async {
        let totalPages = 3
        let pages = (1...totalPages).map { Mocks.moviesPage(page: $0, totalPages: totalPages) }
        var pagination = PaginationCounter()
        
        let sut = PaginationUseCase<MoviesPage>(paginationTask: { currentPage in
            if currentPage == 2 {
                throw TestError.generic
            } else {
                return pages[currentPage - 1]
            }
        })
        
        for pageIndex in pages.indices {
            do {
                let output = try await sut.execute(input: pagination)
                pagination = output.pagination
                expect(output.result).to(equal(pages[pageIndex]))
            } catch {
                expect(error as? TestError).to(equal(.generic))
                break
            }
        }
        expect(pagination.currentPage).to(equal(2))
    }
    
    func testShouldReceivingError_whenTryingToGoOverTheLimit() async {
        let totalPages = 3
        let pages = (1...totalPages).map { Mocks.moviesPage(page: $0, totalPages: totalPages) }
        var pagination = PaginationCounter()
        
        let sut = PaginationUseCase<MoviesPage>(paginationTask: { currentPage in
            pages[currentPage - 1]
        })
        
        for pageIndex in (0...totalPages) {
            do {
                let output = try await sut.execute(input: pagination)
                pagination = output.pagination
                expect(output.result).to(equal(pages[pageIndex]))
            } catch {
                expect(error as? PaginationUseCase<MoviesPage>.PaginationError).to(equal(.reachedTheLimit))
            }
        }
        expect(pagination.currentPage).to(equal(4))
        expect(pagination.isLastPage).to(beTrue())
    }
}
