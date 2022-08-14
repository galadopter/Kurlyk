//
//  RequestType.swift
//  Infrastructure
//
//  Created by Yan Schneider on 27/12/2021.
//

import Foundation

public protocol RequestType {
    var baseURL: URL { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: [String: String]? { get }
}
