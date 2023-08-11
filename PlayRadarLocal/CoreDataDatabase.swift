//
//  CoreDataDatabase.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import CoreData

public final class CoreDataDatabase: DatabaseClient {
    public static let shared = CoreDataDatabase()
    
    private lazy var sharedContext = persistentContainer.newBackgroundContext()
    
    private init() {}
    
    private let modelName           = "PlayRadar"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        
        let frameworkBundle = Bundle(for: Self.self)
        let modelURL = frameworkBundle.url(forResource: modelName, withExtension: "momd")!
        let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
        let container = NSPersistentContainer(name: self.modelName, managedObjectModel: managedObjectModel!)
        container.loadPersistentStores { storeDescription, error in
            
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    public func get<T: EntityLoadable>(_ e: T.Type, where: [String:Any]) async throws -> T? {
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
    
    public func fetch<T: EntityLoadable>(_ e: T.Type, where: [String:Any] = [:]) async throws -> [T] {
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
    
    public func save<T: EntityLoadable>(_ e: T.Type, closure: (T) -> Void) async throws {
        let e = T.entity(sharedContext)
        closure(e)
        
        try sharedContext.save()
    }
    
    public func update<T: EntityLoadable>(_ e: T.Type, where: [String:Any], closure: (T) -> Void) async throws {
        if let existing = try await get(e, where: `where`) {
            closure(existing)
            try sharedContext.save()
        } else {
            try await save(e, closure: closure)
        }
    }
    
    public func delete<T: EntityLoadable>(_ e: T.Type, where: [String:Any]) async throws {
        guard let e = try await get(e, where: `where`) else { return }
        sharedContext.delete(e)
        try sharedContext.save()
    }
}
