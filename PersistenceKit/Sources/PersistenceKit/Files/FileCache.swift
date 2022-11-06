//
//  FileCache.swift
//  
//
//  Created by Yan Schneider on 04/11/2022.
//

import Foundation

class FileCache {
    
    private struct FileContents {
        var stringRepresentation: String
        var url: URL
        var isInitialized: Bool
        
        static func uninitialized(url: URL) -> FileContents {
            .init(stringRepresentation: "", url: url, isInitialized: false)
        }
    }
    
    private var contents: FileContents
    
    var isInitialized: Bool {
        contents.isInitialized
    }
    
    var stringRepresentation: String {
        contents.stringRepresentation
    }
    
    init(storageURL: URL) {
        contents = .uninitialized(url: storageURL)
    }
    
    func initialize() throws {
        let stringRepresentation = try String(contentsOf: contents.url)
        contents.stringRepresentation = stringRepresentation
        contents.isInitialized = true
    }
    
    func update(with newData: String) {
        contents.stringRepresentation = newData
    }
}
