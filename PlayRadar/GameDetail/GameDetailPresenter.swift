//
//  GameDetail.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import Combine

final class GameDetailPresenter {
    let error: AnyPublisher<Error, Never>
    
    private let sError = PassthroughSubject<Error, Never>()
    
    private let interactor: GameDetailInteractor
    private var favorites: Set<String> = []
    private let game: GameModel
    
    init(game: GameModel, interactor: GameDetailInteractor) {
        self.game = game
        error = sError.eraseToAnyPublisher()
        self.interactor = interactor
    }
    
    func getGameDetail() async {
        switch await interactor.getGameDetail(id: game.id) {
        case .success(let detail):
            print("Success get detail")
        case .failure(let error):
            sError.send(error)
        }
    }
    
    func toggleFavorite(for game: GameViewModel) {
        if favorites.contains(game.id) {
            favorites.remove(game.id)
        } else {
            favorites.insert(game.id)
        }
        
        updateFavoriteUI()
    }
    
    private func updateFavoriteUI() {
    }
}
