//
//  EntityLoadable.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import CoreData

protocol EntityLoadable: NSManagedObject {
    static var entityName: String { get }
}

extension EntityLoadable {
    static var entityName: String { "\(Self.self)".replacingOccurrences(of: "CD", with: "") }
    
    static func entity(_ context: NSManagedObjectContext) -> Self {
        let entity = NSEntityDescription.entity(forEntityName: Self.entityName, in: context)!
        return Self.init(entity: entity, insertInto: context)
    }
}
