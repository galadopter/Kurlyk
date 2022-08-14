//
//  NetworkTests.swift
//  InfrastructureTests
//
//  Created by Yan Schnaider on 27/12/2021.
//

import XCTest
import Nimble
import Domain

@testable import NetworkKit

class NetworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        StubbedURLProtocol.reset()
    }

    func testShouldCompleteWithError_whenReceivedExternalError() async throws {
        try await expect(.failure(.noConnection), stub: (nil, nil, TestError.generic))
        try await expect(.failure(.noConnection), stub: (nil, makeHTTPResponse(statusCode: 200), TestError.generic))
        try await expect(.failure(.noConnection), stub: (makeValidData(), makeHTTPResponse(statusCode: 200), TestError.generic))
    }
    
    func testShouldCompleteWithError_whenReceiveBadStatusCode() async throws {
        try await expect(.failure(.badRequest), stub: (nil, makeHTTPResponse(statusCode: 404), nil))
        try await expect(.failure(.serverError), stub: (nil, makeHTTPResponse(statusCode: 500), nil))
        try await expect(.failure(.unauthorized), stub: (nil, makeHTTPResponse(statusCode: 401), nil))
    }
    
    func testShouldCompleteWithError_whenDecodingFailes() async throws {
        try await expect(.failure(.decodingFailed), stub: (makeIncorrectData(), makeHTTPResponse(statusCode: 200), nil))
        try await expect(.failure(.decodingFailed), stub: (makeWrongData(), makeHTTPResponse(statusCode: 200), nil))
    }
    
    func testShouldCompleteSuccessfuly_whenReceiveValidData() async throws {
        let model = Mocks.genericModel(testField: 4)
        let data = makeValidData(model: model)
        try await expect(.success(model), stub: (data, makeHTTPResponse(statusCode: 200), nil))
    }
}

// MARK: - SUT
private extension NetworkTests {
    
    func makeSUT() -> Network<DummyAPI> {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubbedURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return .init(session: session)
    }
}

// MARK: - Helpers
private extension NetworkTests {
    
    typealias NetworkError = Network<DummyAPI>.NetworkError
    typealias Stub = (data: Data?, response: HTTPURLResponse?, error: Error?)
    
    func expect(
        _ expectedResult: Result<GenericModel, NetworkError>,
        stub: Stub,
        file: StaticString = #file, line: UInt = #line
    ) async throws {
        let sut = makeSUT()
        StubbedURLProtocol.simulate(data: stub.data, response: stub.response, error: stub.error)
        do {
            let receivedData: GenericModel = try await sut.fetch(.dummy)
            Nimble.expect(file: file, line: line, receivedData).to(equal(expectedResult.success))
        } catch let error as NetworkError {
            Nimble.expect(file: file, line: line, error).to(equal(expectedResult.failure))
        } catch {
            fail("Got error which is not handled! Error: \(error)")
        }
    }
}
