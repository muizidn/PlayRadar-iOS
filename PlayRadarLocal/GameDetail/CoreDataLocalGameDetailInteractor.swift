//
//  CoreDataLocalGameDetailInteractor.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

public final class CoreDataLocalGameDetailInteractor: LocalGameDetailInteractor {
    private let databaseClient: DatabaseClient
    
    public init(databaseClient: DatabaseClient) {
        self.databaseClient = databaseClient
    }
    
    public func getGameDetail(id: String) async -> Result<GameDetailModel, Error> {
        do {
            guard let game = try await databaseClient.get(CDGame.self, where: ["id": id]) else {
                return .failure(NSError(domain: "LocalGameDetail", code: 1, userInfo: [
                    NSLocalizedDescriptionKey: "not found in local"
                ]))
            }
            return .success(.init(
                game: GameModel(
                    id: game.id,
                    title: game.title,
                    release: game.releaseDate,
                    rating: game.rating),
                publisher: game.publisher,
                playCount: Int(game.playCount),
                gameDescription: game.gameDescription))
        } catch {
            return .failure(error)
        }
    }
    
    public func saveGameDetail(id: String, detail: GameDetailModel) async -> Result<Void, Error> {
        do {
            try await databaseClient.save(CDGame.self, closure: { e in
                e.id = id
                e.playCount = Int16(detail.playCount)
                e.gameDescription = detail.gameDescription
                e.publisher = detail.publisher
            })
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
