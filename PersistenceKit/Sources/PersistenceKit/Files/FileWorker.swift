//
//  FileWorker.swift
//  
//
//  Created by Yan Schneider on 04/11/2022.
//

import Foundation

open class FileWorker {
    
    private let url: URL
    private let cache: FileCache
    private let fileManager: FileManager
    private var _isFileInitialized: Bool?
    
    public enum FileStorageError: Error {
        case failedToLocateDocumentsDirectory
        case failedToCreateFile
        case failedToEncodeData
        case deletingFromEmptyFile
        case readingFromEmptyFile
    }
    
    public init(existingFile url: URL, fileManager: FileManager = .default) {
        self.url = url
        self.fileManager = fileManager
        self.cache = .init(storageURL: url)
    }
    
    public init(fileName: String, fileManager: FileManager = .default) throws {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileStorageError.failedToLocateDocumentsDirectory
        }
        
        url = documentsDirectory.appendingPathComponent("\(fileName).storage")
        self.cache = .init(storageURL: url)
        self.fileManager = fileManager
    }
    
    open func read() throws -> [Data] {
        if !isInitialized { try initialize() }
        if !cache.isInitialized { try cache.initialize() }
        
        return cache.stringRepresentation.split(separator: "\n")
            .compactMap { $0.data(using: .utf8) }
    }
    
    open func append(data: Data) throws {
        if !isInitialized { try initialize() }
        if !cache.isInitialized { try cache.initialize() }
        
        guard let encodedData = String(data: data, encoding: .utf8) else {
            throw FileStorageError.failedToEncodeData
        }
        
        try makeUpdatesToFile { file in
            file.append(encodedData + "\n")
        }
    }
    
    open func replace(withContentsOf dataCollection: [Data]) throws {
        if !isInitialized { try initialize() }
        if !cache.isInitialized { try cache.initialize() }
        
        try makeUpdatesToFile { file in
            let lines = try dataCollection.map { data -> String in
                guard let encodedData = String(data: data, encoding: .utf8) else {
                    throw FileStorageError.failedToEncodeData
                }
                return encodedData
            }
            file = lines.joined(separator: "\n") + "\n"
        }
    }
}

// MARK: - Private
private extension FileWorker {
    
    var isInitialized: Bool {
        _isFileInitialized ?? fileManager.fileExists(atPath: url.path)
    }
    
    func initialize() throws {
        guard fileManager.createFile(atPath: url.path, contents: nil) else {
            throw FileStorageError.failedToCreateFile
        }
        _isFileInitialized = true
    }
    
    func makeUpdatesToFile(_ closure: (inout String) throws -> Void) throws {
        var stringRepresentation = cache.stringRepresentation
        try closure(&stringRepresentation)
        try stringRepresentation.write(toFile: url.path, atomically: false, encoding: .utf8)
        cache.update(with: stringRepresentation)
    }
}
