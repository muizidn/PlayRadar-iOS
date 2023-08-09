//
//  FavoriteRouter.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit
import PlayRadar

final class FavoriteTabBarChildRouter: Router {
    private let tabBar: UITabBarController
    
    init(tabBar: UITabBarController) {
        self.tabBar = tabBar
    }
    
    private(set) weak var viewController: UIViewController!
    
    @discardableResult
    func launch() -> UIViewController {
        let vc = FavoriteListViewController(
            presenter: GameListPresenter(
                interactor: GameListAPIInteractor()
            )
        )
        self.viewController = vc
        
        vc.tabBarItem = UITabBarItem(
            title: "Favorite",
            image: UIImage(named: "Favorite"),
            selectedImage: UIImage(named: "Favorite_fill"))
        tabBar.viewControllers?.append(vc)
        return vc
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
    
    class DummyPresenter: IGameListPresenter {
        func getGame(at index: Int) -> GameModel {
            fatalError()
        }
    }
}
#endif
