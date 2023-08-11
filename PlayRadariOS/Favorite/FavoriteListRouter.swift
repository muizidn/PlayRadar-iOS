//
//  FavoriteRouter.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit
import Combine
import PlayRadar
import PlayRadarRemote
import PlayRadarLocal

protocol FavoriteListRouter: Router {
    func launchDetail(game: GameModel)
}

final class FavoriteTabBarChildRouter: NSObject, FavoriteListRouter {
    private let tabBar: UITabBarController
    
    init(tabBar: UITabBarController) {
        self.tabBar = tabBar
    }
    
    private(set) var viewController: UIViewController!
    
    @discardableResult
    func launch() -> UIViewController {
        let vc = FavoriteListViewController(
            presenter: GameListPresenter(
                interactor: CoreDataLocalFavoriteGameListInteractor(),
                loaderStrategy: .update
            ),
            router: WeakProxy(self)
        )
        self.viewController = vc
        
        vc.tabBarItem = UITabBarItem(
            title: "Favorite",
            image: UIImage(named: "Favorite"),
            selectedImage: UIImage(named: "Favorite_fill"))
        tabBar.viewControllers?.append(UINavigationController(rootViewController: vc))
        return vc
    }
    
    func launchDetail(game: GameModel) {
        let router = PushGameDetailRouter(navigationController: viewController.navigationController!, game: game)
        router.launch()
    }
}

extension WeakProxy: FavoriteListRouter where T: FavoriteListRouter {
    func launchDetail(game: GameModel) {
        proxy!.launchDetail(game: game)
    }
}

#if DEBUG
import SwiftUI

struct FavoriteListRouter_Previews: PreviewProvider {
    static var previews: some View {
        RouterPreviewContainer {
            return FavoriteTabBarChildRouter(tabBar: UITabBarController())
        }
    }
}
#endif
