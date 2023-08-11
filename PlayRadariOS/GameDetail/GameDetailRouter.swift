//
//  GameDetailRouter.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit
import PlayRadar
import PlayRadarRemote
import PlayRadarLocal

final class PushGameDetailRouter: Router {
    private var vc: GameDetailViewController!
    private let navigationController: UINavigationController
    private let game: GameModel
    init(navigationController: UINavigationController, game: GameModel) {
        self.navigationController = navigationController
        self.game = game
    }
    
    @discardableResult
    func launch() -> UIViewController {
        vc = GameDetailViewController(presenter: GameDetailPresenter(
            game: game,
            detailInteractor: GameDetailRemoteWithLocalFallbackInteractor(
                remote: RemoteGameDetailInteractor(httpClient: URLSession.shared),
                local: CoreDataLocalGameDetailInteractor(databaseClient: CoreDataDatabase.shared)),
            favoriteInteractor: CoreDataLocalFavoriteGameInteractor(databaseClient: CoreDataDatabase.shared)))
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
}

#if DEBUG
import SwiftUI

struct GameDetailRouter_Previews: PreviewProvider {
    static var previews: some View {
        ControllerPreviewContainer {
            let nav = UINavigationController()
            PushGameDetailRouter(navigationController: nav,
                                 game: GameModel(
                                    id: "1",
                                    title: "",
                                    release: Date(timeIntervalSince1970: 0),
                                    rating: 2))
            .launch()
            return nav
        }
    }
}
#endif


#if DEBUG
final class UITestingGameDetailRouter: Router {
    private var vc: GameDetailViewController!
    private let navigationController: UINavigationController
    private let game: GameModel
    init(navigationController: UINavigationController, game: GameModel) {
        self.navigationController = navigationController
        self.game = game
    }
    
    @discardableResult
    func launch() -> UIViewController {
        let interactor = MockInteractor()
        vc = GameDetailViewController(presenter: GameDetailPresenter(
            game: game,
            detailInteractor: interactor,
            favoriteInteractor: interactor))
        navigationController.pushViewController(vc, animated: true)
        return vc
    }
}

fileprivate class MockInteractor: GameDetailInteractor, FavoriteGameInteractor {
    func getGameDetail(id: String) async -> Result<GameDetailModel, Error> {
        return .success(.init(
            game: GameModel(
                id: id,
                title: "Game \(id)",
                release: Date(timeIntervalSince1970: 0), rating: 1),
            publisher: "publisher \(id)",
            playCount: 1,
            gameDescription: "description \(id)"))
    }
    
    private var favorites: [String:Bool] = [:]
    
    func setFavorite(id: String, favorite: Bool) async {
        favorites[id] = favorite
    }
    
    func getFavorite(id: String) async -> Bool {
        favorites[id] ?? false
    }
}

#endif
