//
//  GameListPresenter.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import Combine

final class GameListPresenter {
    let games: AnyPublisher<[GameViewModel], Never>
    
    private let sGames = CurrentValueSubject<[GameViewModel], Never>([])
    
    init() {
        games = sGames.eraseToAnyPublisher()
    }
    
    func loadGames() async {
        sGames.send([
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(),
                rating: 4.2),
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(),
                rating: 4.2),
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "BioShock 2 Remastered Japan Version",
                releaseDate: Date(),
                rating: 4.2)
        ])
    }
}
