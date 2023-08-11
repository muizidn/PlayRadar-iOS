//
//  CDFavorite.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import CoreData

@objc(Favorite)
final class CDFavorite: NSManagedObject, EntityLoadable {
    @NSManaged var id: String
    @NSManaged var game: CDGame
}
