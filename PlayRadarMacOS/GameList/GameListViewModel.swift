//
//  GameListViewModel.swift
//  PlayRadarMacOS
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation
import Combine
import PlayRadar
import PlayRadarRemote
import PlayRadarLocal

class GameListViewModel: ObservableObject {
    @Published var games: [GameViewModel] = []
    @Published var isLoadingNextGames: Bool = false
    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let presenter: GameListPresenter

    private let decoratedInteractor: GameListViewModelDecorator
    
    init(interactor: GameListInteractor) {
        decoratedInteractor = GameListViewModelDecorator(decoratee: interactor)
        presenter = GameListPresenter(interactor: decoratedInteractor)

        presenter.games
            .receive(on: DispatchQueue.main)
            .assign(to: \.games, on: self)
            .store(in: &cancellables)

        presenter.loadingNextGames
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoadingNextGames, on: self)
            .store(in: &cancellables)
    }

    func loadGames() {
        Task {
            await presenter.loadGames()
        }
    }

    func loadNextGamesIfNeeded(_ game: GameViewModel) {
        if let lastGame = games.last, game.id == lastGame.id {
            Task {
                await presenter.nextGames()
            }
        }
    }

    func searchGames() {
        Task {
            await presenter.searchGames(query: searchText)
        }
    }

    func getGame(with id: String) -> GameModel {
        return decoratedInteractor.games[id]!
    }
}

private class GameListViewModelDecorator: GameListInteractor {
    let decoratee: GameListInteractor
    
    init(decoratee: GameListInteractor) {
        self.decoratee = decoratee
    }
    
    private(set) var games: [String:GameModel] = [:]
    
    func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error> {
        let result = await decoratee.loadGames(page: page)
        if case .success(let success) = result {
            assignGames(with: success.data)
        }
        return result
    }
    
    func searchGames(query: String) async -> Result<[PlayRadar.GameModel], Error> {
        let result = await decoratee.searchGames(query: query)
        if case .success(let success) = result {
            assignGames(with: success)
        }
        return result
    }
    
    private func assignGames(with games: [GameModel]) {
        for game in games {
            self.games[game.id] = game
        }
    }
}
