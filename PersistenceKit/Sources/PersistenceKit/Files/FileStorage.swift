//
//  FileStorage.swift
//  
//
//  Created by Yan Schneider on 04/11/2022.
//

import Foundation

public actor FileStorage<T: Codable & Identifiable>: Storage {
    
    private let worker: FileWorker
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    public typealias Model = T
    public typealias ModelID = T.ID
    
    public enum FileStorageError: Error {
        case removingNonExistentValue
    }
    
    public init(worker: FileWorker, decoder: JSONDecoder = .init(), encoder: JSONEncoder = .init()) {
        self.worker = worker
        self.decoder = decoder
        self.encoder = encoder
    }
    
    public func get() async throws -> [T] {
        try worker.read()
            .map { try decoder.decode(T.self, from: $0) }
    }
    
    public func save(_ model: T) async throws {
        let data = try encoder.encode(model)
        try worker.append(data: data)
    }
    
    public func remove(_ modelID: T.ID) async throws -> T {
        let decodedModels = try worker.read()
            .map { try decoder.decode(T.self, from: $0) }
        
        guard let modelToRemove = decodedModels.first(where: { $0.id == modelID }) else {
            throw FileStorageError.removingNonExistentValue
        }
        
        let dataCollection = try decodedModels.compactMap { model -> Data? in
            if model.id == modelID {
                return nil
            } else {
                return try encoder.encode(model)
            }
        }
        
        try worker.replace(withContentsOf: dataCollection)
        
        return modelToRemove
    }
    
    public func contains(_ modelID: T.ID) async throws -> Bool {
        try worker.read()
            .map { try decoder.decode(T.self, from: $0) }
            .contains(where: { $0.id == modelID })
    }
}
