//
//  CoreDataLocalFavoriteGameInteractor.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

public final class CoreDataLocalFavoriteGameInteractor: FavoriteGameInteractor {
    public init() {}
    public func setFavorite(id: String, favorite: Bool) async {
        do {
            if favorite {
                guard let game = try await CoreDataDatabase.shared.get(CDGame.self, where: ["id": id]) else { return }
                try await CoreDataDatabase.shared.save(CDFavorite.self) { e in
                    e.id = id
                    e.game = game
                }
            } else {
                try await CoreDataDatabase.shared.delete(CDFavorite.self, where: ["id": id])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getFavorite(id: String) async -> Bool {
        do {
            return try await CoreDataDatabase.shared.get(CDFavorite.self, where: ["id": id]) != nil
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}
