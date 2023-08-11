//
//  CoreDataDatabase.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import CoreData

final class CoreDataDatabase {
    static let shared = CoreDataDatabase()
    
    private lazy var sharedContext = persistentContainer.newBackgroundContext()
    
    private init() {}
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PlayRadar")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func get<T: EntityLoadable>(_ e: T.Type, where: [String:Any]) async throws -> T? {
        var predicates: [NSPredicate] = []

        for (key, value) in `where` {
            let predicate = NSPredicate(format: "%K == %@", key, value as! NSObject)
            predicates.append(predicate)
        }

        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        
        let fetchReq = NSFetchRequest<T>(entityName: T.entityName)
        fetchReq.predicate = compoundPredicate
        fetchReq.fetchLimit = 1
        return try sharedContext.fetch(fetchReq).first
    }
    
    func fetch<T: EntityLoadable>(_ e: T.Type, where: [String:Any] = [:]) async throws -> [T] {
        var predicates: [NSPredicate] = []

        for (key, value) in `where` {
            let predicate = NSPredicate(format: "%K == %@", key, value as! NSObject)
            predicates.append(predicate)
        }

        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        
        let fetchReq = NSFetchRequest<T>(entityName: T.entityName)
        fetchReq.predicate = compoundPredicate
        return try sharedContext.fetch(fetchReq)
    }
    
    func save<T: EntityLoadable>(_ e: T.Type, closure: (T) -> Void) async throws {
        let e = T.entity(sharedContext)
        closure(e)
        
        try sharedContext.save()
    }
    
    func update<T: EntityLoadable>(_ e: T.Type, where: [String:Any], closure: (T) -> Void) async throws {
        if let existing = try await get(e, where: `where`) {
            closure(existing)
            try sharedContext.save()
        } else {
            try await save(e, closure: closure)
        }
    }
    
    func delete<T: EntityLoadable>(_ e: T.Type, where: [String:Any]) async throws {
        guard let e = try await get(e, where: `where`) else { return }
        sharedContext.delete(e)
        try sharedContext.save()
    }
}
