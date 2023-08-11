//
//  GameListViewModel.swift
//  PlayRadarMacOS
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation
import Combine
import PlayRadar

class GameListViewModel: ObservableObject {
    @Published var games: [GameViewModel] = []
    @Published var isLoadingNextGames: Bool = false
    @Published var searchText: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let presenter: GameListPresenter

    init(interactor: GameListInteractor) {
        presenter = GameListPresenter(interactor: interactor)

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

    func getGame(at index: Int) -> GameModel {
        return presenter.getGame(at: index)
    }
}

