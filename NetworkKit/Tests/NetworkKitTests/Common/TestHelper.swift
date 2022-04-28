//
//  TestHelper.swift
//  Infrastructure
//
//  Created by Yan Schnaider on 27/12/2021.
//

import Foundation

@testable import NetworkKit

struct GenericModel: Codable, Equatable {
    let testField: Int
}

struct Mocks {
    
    static func genericModel(testField: Int = 1) -> GenericModel {
        .init(testField: testField)
    }
}

enum TestError: Error {
    case generic
}

func makeValidData(model: GenericModel = Mocks.genericModel()) -> Data {
    Data("{\"testField\":\(model.testField)}".utf8)
}

func makeIncorrectData() -> Data {
    Data("error".utf8)
}

func makeWrongData() -> Data {
    Data("{\"key\":\"value\"}".utf8)
}

func makeHTTPResponse(statusCode: Int) -> HTTPURLResponse? {
    .init(url: DummyAPI.dummy.baseURL, statusCode: statusCode, httpVersion: nil, headerFields: nil)
}

extension Result {
    
    var success: Success? {
        guard case let .success(value) = self else { return nil }
        return value
    }
    
    var failure: Failure? {
        guard case let .failure(error) = self else { return nil }
        return error
    }
}
