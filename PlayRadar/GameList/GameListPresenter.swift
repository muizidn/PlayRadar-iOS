//
//  GameListPresenter.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import Combine

public protocol IGameListPresenter {
    var games: AnyPublisher<[GameViewModel], Never> { get }
    func loadGames() async
    func getGame(at index: Int) -> GameModel
}

public final class GameListPresenter: IGameListPresenter {
    public let games: AnyPublisher<[GameViewModel], Never>
    let error: AnyPublisher<Error, Never>
    
    private let sGames = CurrentValueSubject<[GameViewModel], Never>([])
    private let sError = PassthroughSubject<Error, Never>()
    
    private var gamesModel = [GameModel]()
    
    private let interactor: GameListInteractor
    private var nextPage = 1
    
    public init(interactor: GameListInteractor) {
        games = sGames.eraseToAnyPublisher()
        error = sError.eraseToAnyPublisher()
        self.interactor = interactor
    }
    
    public func loadGames() async {
        switch await interactor.loadGames(page: nextPage) {
        case .success(let result):
            sGames.send(result.data.map({ .from($0) }))
            gamesModel.append(contentsOf: result.data)
        case .failure(let error):
            sError.send(error)
        }
    }
    
    public func searchGames(query: String) async {
        switch await interactor.searchGames(query: query) {
        case .success(let result):
            sGames.send(result.map({ .from($0) }))
        case .failure(let error):
            sError.send(error)
        }
    }
    
    public func getGame(at index: Int) -> GameModel {
        return gamesModel[index]
    }
}


extension GameViewModel {
    static func from(_ game: GameModel) -> GameViewModel {
        return .init(id:game.id, coverImage: game.cover, title: game.title, releaseDate: game.release, rating: game.rating)
    }
}
