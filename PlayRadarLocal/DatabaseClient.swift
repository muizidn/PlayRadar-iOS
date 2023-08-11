//
//  DatabaseClient.swift
//  PlayRadarLocal
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation
import CoreData

public protocol DatabaseClient {
    func get<T: EntityLoadable>(_ e: T.Type, where: [String:Any]) async throws -> T?
    func fetch<T: EntityLoadable>(_ e: T.Type, where: [String:Any]) async throws -> [T]
    func save<T: EntityLoadable>(_ e: T.Type, closure: (T) -> Void) async throws
    func update<T: EntityLoadable>(_ e: T.Type, where: [String:Any], closure: (T) -> Void) async throws
    func delete<T: EntityLoadable>(_ e: T.Type, where: [String:Any]) async throws
}
