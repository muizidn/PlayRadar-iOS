//
//  GameListInteractor.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import Combine

public protocol GameListInteractor {
    func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error>
    func searchGames(query: String) async -> Result<[GameModel], Error>
}

public final class GameListAPIInteractor: GameListInteractor {
    public init() {}
    public func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error> {
        return .success(.init(data: [
            GameModel(
                id: "1",
                cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                publisher: "Microsoft Game Studio",
                release: Date(),
                rating: 4.2),
            GameModel(
                id: "2",
                cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                publisher: "Electronic Arts",
                release: Date(),
                rating: 4.2),
            GameModel(
                id: "3",
                cover: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                publisher: "Kyoto Game Studio",
                release: Date(),
                rating: 4.2),
            ], page: page, count: 0, hasNext: true))
    }
    
    public func searchGames(query: String) async -> Result<[GameModel], Error> {
        return .success([])
    }
}
