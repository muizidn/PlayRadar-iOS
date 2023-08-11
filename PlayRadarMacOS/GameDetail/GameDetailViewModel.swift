//
//  GameDetailViewModel.swift
//  PlayRadarMacOS
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation
import Combine
import PlayRadar
import PlayRadarRemote
import PlayRadarLocal

class GameDetailViewModel: ObservableObject {
    private let presenter: GameDetailPresenter

    @Published var coverImage: URL?
    @Published var publisher: String = ""
    @Published var gameTitle: String = ""
    @Published var releaseDate: String = ""
    @Published var rating: String = ""
    @Published var playCount: String = ""
    @Published var gameDescription: NSAttributedString = NSAttributedString()

    @Published var isFavorite: Bool = false
    @Published var error: Error? = nil
    
    private var cancellables = Set<AnyCancellable>()

    init(game: GameModel, detailInteractor: GameDetailInteractor, favoriteInteractor: FavoriteGameInteractor) {
        presenter = GameDetailPresenter(game: game, detailInteractor: detailInteractor, favoriteInteractor: favoriteInteractor)

        setupBindings()
    }

    private func setupBindings() {
        presenter.detail
            .map(\.game.cover)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coverURL in
                self?.coverImage = coverURL
            }
            .store(in: &cancellables)

        presenter.detail
            .map(\.publisher)
            .receive(on: DispatchQueue.main)
            .assign(to: &$publisher)

        presenter.detail
            .map(\.game.title)
            .receive(on: DispatchQueue.main)
            .assign(to: &$gameTitle)

        presenter.releaseAt
            .receive(on: DispatchQueue.main)
            .assign(to: &$releaseDate)

        presenter.rating
            .receive(on: DispatchQueue.main)
            .assign(to: &$rating)

        presenter.playCount
            .receive(on: DispatchQueue.main)
            .assign(to: &$playCount)

        presenter.detail
            .map(\.gameDescription)
            .map { NSAttributedString(string: $0) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$gameDescription)

        presenter.isFavorite
            .receive(on: DispatchQueue.main)
            .assign(to: &$isFavorite)
    }
    
    func getDetail() {
        presenter.getGameDetail()
    }
    
    func getFavorite() {
        presenter.getFavorite()
    }
    
    func toggleFavorite() {
        presenter.toggleFavorite()
    }
}

func createDetailViewModel(forGame game: GameModel) -> GameDetailViewModel {
    GameDetailViewModel(
        game: game,
        detailInteractor: RemoteGameDetailInteractor(),
        favoriteInteractor: CoreDataLocalFavoriteGameInteractor())
}

