//
//  LocalFavoriteGameInteractor.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

final class LocalFavoriteGameInteractor: FavoriteGameInteractor {
    func setFavorite(id: String, favorite: Bool) async {
        do {
            if favorite {
                try await CoreDataDatabase.shared.save(CDFavorite.self) { e in
                    e.id = id
                }
            } else {
                try await CoreDataDatabase.shared.delete(CDFavorite.self, where: ["id": id])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getFavorite(id: String) async -> Bool {
        do {
            return try await CoreDataDatabase.shared.get(CDFavorite.self, where: ["id": id]) != nil
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}
