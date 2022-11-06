//
//  Storage.swift
//  
//
//  Created by Yan Schneider on 04/11/2022.
//

import Foundation

public protocol Storage<Model, ModelID> {
    
    associatedtype Model: Codable & Identifiable
    
    // Workaround for current swift version, consider removing it in the future
    associatedtype ModelID: Hashable where Model.ID == ModelID
    
    /// Gets all values, that are stored inside a storage
    func get() async throws -> [Model]
    
    /// Saves value inside a storage
    func save(_ model: Model) async throws
    
    @discardableResult
    /// Removes value from storage
    func remove(_ modelID: Model.ID) async throws -> Model
    
    /// Finds if value is inside a storage
    func contains(_ modelID: Model.ID) async throws -> Bool
}
