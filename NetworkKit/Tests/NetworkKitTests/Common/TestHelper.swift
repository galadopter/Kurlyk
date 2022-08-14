//
//  File.swift
//  
//
//  Created by Yan Schneider on 14/08/2022.
//

import Foundation

@testable import NetworkKit

struct GenericModel: Codable, Equatable {
    let testField: Int
}

enum Mocks {
    
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
    .init(url: URL(string: "www.google.com/")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
}
