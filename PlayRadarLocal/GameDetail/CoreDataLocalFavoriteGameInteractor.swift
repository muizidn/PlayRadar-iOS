//
//  CoreDataLocalFavoriteGameInteractor.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

public final class CoreDataLocalFavoriteGameInteractor: FavoriteGameInteractor {
    private let databaseClient: DatabaseClient
    
    public init(databaseClient: DatabaseClient) {
        self.databaseClient = databaseClient
    }
    
    public func setFavorite(id: String, favorite: Bool) async {
        do {
            if favorite {
                guard let game = try await databaseClient.get(CDGame.self, where: ["id": id]) else { return }
                try await databaseClient.save(CDFavorite.self) { e in
                    e.id = id
                    e.game = game
                }
            } else {
                try await databaseClient.delete(CDFavorite.self, where: ["id": id])
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getFavorite(id: String) async -> Bool {
        do {
            return try await databaseClient.get(CDFavorite.self, where: ["id": id]) != nil
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}
