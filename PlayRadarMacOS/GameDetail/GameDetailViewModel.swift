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
            .sink { [weak self] coverURL in
                self?.coverImage = coverURL
            }
            .store(in: &cancellables)

        presenter.detail
            .map(\.publisher)
            .assign(to: &$publisher)

        presenter.detail
            .map(\.game.title)
            .assign(to: &$gameTitle)

        presenter.releaseAt
            .assign(to: &$releaseDate)

        presenter.rating
            .assign(to: &$rating)

        presenter.playCount
            .assign(to: &$playCount)

        presenter.detail
            .map(\.gameDescription)
            .map { NSAttributedString(string: $0) }
            .assign(to: &$gameDescription)

        presenter.isFavorite
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

