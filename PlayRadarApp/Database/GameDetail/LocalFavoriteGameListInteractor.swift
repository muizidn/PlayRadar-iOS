//
//  LocalFavoriteGameListInteractor.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

final class LocalFavoriteGameListInteractor: GameListInteractor {
    func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error> {
        do {
            let favorites = try await CoreDataDatabase.shared.fetch(CDFavorite.self)
            let data = favorites.map { favorite in
                favorite.game
            }.map { game in
                GameModel(id: game.id,
                          cover: game.cover,
                          title: game.title,
                          release: game.releaseDate,
                          rating: game.rating)
            }
            return .success(.init(data: data, page: 1, count: data.count, hasNext: false))
        } catch {
            return .failure(error)
        }
        
    }
    // FIXME: this is violation of Interface Segregation Principle
    func searchGames(query: String) async -> Result<[GameModel], Error> {
        fatalError()
    }
}
