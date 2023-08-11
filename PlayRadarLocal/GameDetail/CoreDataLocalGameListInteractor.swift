//
//  CoreDataLocalGameListInteractor.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

public final class CoreDataLocalGameListInteractor: LocalGameListInteractor {
    private let databaseClient: DatabaseClient
    
    public init(databaseClient: DatabaseClient) {
        self.databaseClient = databaseClient
    }
    
    public func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error> {
        do {
            let games = try await databaseClient.fetch(CDGame.self, where: [:])
            let data = games.map { game in
                GameModel(id: game.id, title: game.title, release: game.releaseDate, rating: game.rating)
            }
            return .success(.init(data: data, page: 1, count: data.count, hasNext: false))
        } catch {
            return .failure(error)
        }
        
    }
    
    public func saveGames(_ games: [GameModel]) async -> Result<Void, Error> {
        do {
            for game in games {
                try await databaseClient.update(CDGame.self, where: ["id": game.id], closure: { e in
                    e.id = game.id
                    e.title = game.title
                    e.cover = game.cover
                    e.rating = game.rating
                    e.releaseDate = game.release
                })
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    // FIXME: this is violation of Interface Segregation Principle
    public func searchGames(query: String) async -> Result<[GameModel], Error> {
        fatalError()
    }
}
