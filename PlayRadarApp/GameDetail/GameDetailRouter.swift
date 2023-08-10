//
//  GameDetailRouter.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit
import PlayRadar

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
            detailInteractor: GameDetailAPIInteractor(),
            favoriteInteractor: LocalFavoriteGameInteractor()))
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
                                    release: Date(),
                                    rating: 2))
                .launch()
            return nav
        }
    }
}
#endif
