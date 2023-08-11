//
//  GameListRouter.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit
import Combine
import PlayRadar
import PlayRadarLocal
import PlayRadarRemote

protocol GameListRouter: Router {
    func launchDetail(game: GameModel)
}


final class GameListTabBarChildRouter: NSObject, GameListRouter {
    private let tabBar: UITabBarController
    
    init(tabBar: UITabBarController) {
        self.tabBar = tabBar
    }
    
    private(set) var viewController: UIViewController!
    
    @discardableResult
    func launch() -> UIViewController {
        let vc = GameListViewController(
            presenter: GameListPresenter(
                interactor: GameListRemoteWithLocalFallbackInteractor(
                    remote: RemoteGameListInteractor(),
                    local: CoreDataLocalGameListInteractor()
                )
            ),
            router: WeakProxy(self)
        )
        self.viewController = vc
        
        vc.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "Home"),
            selectedImage: UIImage(named: "Home_fill"))
        tabBar.viewControllers?.append(UINavigationController(rootViewController: vc))
        return vc
    }
    
    func launchDetail(game: GameModel) {
        let router = PushGameDetailRouter(
            navigationController: viewController.navigationController!,
            game: game)
        router.launch()
    }
}

extension WeakProxy: GameListRouter where T: GameListRouter {
    func launchDetail(game: GameModel) {
        proxy!.launchDetail(game: game)
    }
}

#if DEBUG
import SwiftUI

struct GameListRouter_Previews: PreviewProvider {
    static var previews: some View {
        RouterPreviewContainer {
            return GameListTabBarChildRouter(tabBar: UITabBarController())
        }
    }
}
#endif
