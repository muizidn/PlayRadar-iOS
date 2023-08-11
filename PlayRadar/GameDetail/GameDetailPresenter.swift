//
//  GameDetail.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation
import Combine

public final class GameDetailPresenter {
    public let detail: AnyPublisher<GameDetailModel, Never>
    public let isFavorite: AnyPublisher<Bool, Never>
    let error: AnyPublisher<Error, Never>
    
    private let sError = PassthroughSubject<Error, Never>()
    private let sFavorite = CurrentValueSubject<Bool, Never>(false)
    private let sDetail = PassthroughSubject<GameDetailModel, Never>()
    
    private let detailInteractor: GameDetailInteractor
    private let favoriteInteractor: FavoriteGameInteractor
    private let game: GameModel
    
    public init(game: GameModel, detailInteractor: GameDetailInteractor, favoriteInteractor: FavoriteGameInteractor) {
        self.game = game
        self.favoriteInteractor = favoriteInteractor
        self.detailInteractor = detailInteractor
        
        error = sError.eraseToAnyPublisher()
        isFavorite = sFavorite.eraseToAnyPublisher()
        detail = sDetail.eraseToAnyPublisher()
    }
    
    public func getFavorite() {
        Task {
            let isFavorite = await favoriteInteractor.getFavorite(id:game.id)
            await updateFavoriteUI(favorite: isFavorite)
        }
    }
    
    public func getGameDetail() {
        Task {
            switch await detailInteractor.getGameDetail(id: game.id) {
            case .success(let detail):
                sDetail.send(detail)
            case .failure(let error):
                sError.send(error)
            }
        }
    }
    
    public func toggleFavorite() {
        Task {
            var isFavorite = sFavorite.value;
            isFavorite.toggle()
            
            await favoriteInteractor.setFavorite(
                id:game.id,
                favorite: isFavorite
            )
            
            await updateFavoriteUI(favorite: isFavorite)
        }
    }
    
    @MainActor
    private func updateFavoriteUI(favorite: Bool) {
        sFavorite.send(favorite)
    }
}
