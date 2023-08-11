//
//  CDGame.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import CoreData

@objc(Game)
final class CDGame: NSManagedObject, EntityLoadable {
    @NSManaged var id: String
    @NSManaged var cover: URL?
    @NSManaged var title: String
    @NSManaged var publisher: String
    @NSManaged var releaseDate: Date
    @NSManaged var playCount: Int16
    @NSManaged var rating: Double
    @NSManaged var gameDescription: String
}

