//
//  SpyDatabaseClient.swift
//  PlayRadarLocalTests
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation
@testable import PlayRadarLocal

class SpyDatabaseClient: DatabaseClient {
    init(spied: DatabaseClient) {
        self.spied = spied
    }
    
    let spied: DatabaseClient
    
    var saveCalled = false
    var deleteCalled = false
    var getCalled = false
    var updateCalled = false
    var fetchCalled = false
    
    func get<T: EntityLoadable>(_ entity: T.Type, where conditions: [String : Any]) async throws -> T? {
        getCalled = true
        return try await spied.get(entity, where: conditions)
    }
    
    func save<T: EntityLoadable>(_ entity: T.Type, closure: (T) -> Void) async throws {
        saveCalled = true
        try await spied.save(entity, closure: closure)
    }
    
    func delete<T: EntityLoadable>(_ entity: T.Type, where conditions: [String : Any]) async throws {
        deleteCalled = true
        try await spied.delete(entity, where: conditions)
    }
    
    func fetch<T>(_ entity: T.Type, where conditions: [String : Any]) async throws -> [T] where T : EntityLoadable {
        fetchCalled = true
        return try await spied.fetch(entity, where: conditions)
    }
    
    func update<T>(_ e: T.Type, where: [String : Any], closure: (T) -> Void) async throws where T : EntityLoadable {
        updateCalled = true
        try await spied.update(e, where: `where`, closure: closure)
    }
    
    func prefillDatabase<T: EntityLoadable & SetWithId>(_ e: T.Type,ids: [String]) async throws {
        for id in ids {
            try await CoreDataDatabase.shared.save(T.self) { e in
                e.id = id
            }
        }
    }
    
    func clearDatabase() async throws {
        for item in try await CoreDataDatabase.shared.fetch(CDGame.self) {
            try await CoreDataDatabase.shared.delete(CDGame.self, where: ["id":item.id])
        }
        for item in try await CoreDataDatabase.shared.fetch(CDFavorite.self) {
            try await CoreDataDatabase.shared.delete(CDFavorite.self, where: ["id":item.id])
        }
    }
}

protocol SetWithId: NSObject {
    var id: String { get set }
}

extension CDGame: SetWithId {}
extension CDFavorite: SetWithId {}
