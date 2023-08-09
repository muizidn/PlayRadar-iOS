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
    let error: AnyPublisher<Error, Never>
    
    private let sGames = CurrentValueSubject<[GameViewModel], Never>([])
    private let sError = PassthroughSubject<Error, Never>()
    
    private let interactor: GameListInteractor
    private var nextPage = 1
    
    init(interactor: GameListInteractor) {
        games = sGames.eraseToAnyPublisher()
        error = sError.eraseToAnyPublisher()
        self.interactor = interactor
    }
    
    func loadGames() async {
        switch await interactor.loadGames(page: nextPage) {
        case .success(let result):
            sGames.send(result.data.map({ .from($0) }))
        case .failure(let error):
            sError.send(error)
        }
    }
    
    func searchGames(query: String) async {
        sGames.send([
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "The World Voyage 3 USA Version",
                releaseDate: Date(),
                rating: 4.2),
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "The World Voyage 3 USA Version",
                releaseDate: Date(),
                rating: 4.2),
            GameViewModel(
                coverImage: URL(string: "https://media.rawg.io/media/resize/420/-/screenshots/d0e/d0e70feaab57195e8286f3501e95fc5e.jpg"),
                title: "The World Voyage 3 USA Version",
                releaseDate: Date(),
                rating: 4.2)
        ])
    }
}


extension GameViewModel {
    static func from(_ game: GameModel) -> GameViewModel {
        return .init(coverImage: game.cover, title: game.title, releaseDate: game.release, rating: game.rating)
    }
}
