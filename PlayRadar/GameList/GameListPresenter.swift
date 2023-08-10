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
    var loadingNextGames: AnyPublisher<Bool, Never> { get }
    func loadGames() async
    func nextGames() async
    func getGame(at index: Int) -> GameModel
    func searchGames(query: String) async
}

public final class GameListPresenter: IGameListPresenter {
    public enum LoaderStrategy {
        case append
        case update
    }
    
    public let games: AnyPublisher<[GameViewModel], Never>
    public let loadingNextGames: AnyPublisher<Bool, Never>
    let error: AnyPublisher<Error, Never>
    
    private let sGames = CurrentValueSubject<[GameViewModel], Never>([])
    private let sError = PassthroughSubject<Error, Never>()
    private let sLoadingNextGames = PassthroughSubject<Bool, Never>()
    private let sSearch = PassthroughSubject<String, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var gamesModel = [GameModel]()
    
    private let loaderStrategy: LoaderStrategy
    
    private let interactor: GameListInteractor
    private var nextPage = 1
    private var hasNext = true
    
    public init(interactor: GameListInteractor, loaderStrategy: LoaderStrategy = .append ) {
        games = sGames.eraseToAnyPublisher()
        error = sError.eraseToAnyPublisher()
        loadingNextGames = sLoadingNextGames.eraseToAnyPublisher()
        self.interactor = interactor
        self.loaderStrategy = loaderStrategy
        
        sSearch
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [unowned self] query in
                Task {
                    await actualSearchGames(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    public func loadGames() async {
        switch await interactor.loadGames(page: nextPage) {
        case .success(let result):
            var games = sGames.value
            let newGamesViewModel = result.data.map({ GameViewModel.from($0) })
            switch loaderStrategy {
            case .append:
                games.append(contentsOf:  newGamesViewModel)
                gamesModel.append(contentsOf: result.data)
            case .update:
                games = newGamesViewModel
                gamesModel = result.data
            }
            sGames.send(games)
            
            hasNext = result.hasNext
            if hasNext {
                nextPage = result.page + 1
            }
        case .failure(let error):
            sError.send(error)
        }
    }
    
    public func nextGames() async {
        if hasNext {
            sLoadingNextGames.send(true)
            defer { sLoadingNextGames.send(false) }
            await loadGames()
        } else {
            sLoadingNextGames.send(false)
        }
    }
    
    public func searchGames(query: String) async {
        sSearch.send(query)
    }
    
    private func actualSearchGames(query: String) async {
        switch await interactor.searchGames(query: query) {
        case .success(let result):
            sGames.send(result.map({ .from($0) }))
            gamesModel.removeAll(keepingCapacity: true)
            hasNext = false
            nextPage = 1
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
