//
//  GameListRouter.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit
import PlayRadar

final class GameListTabBarChildRouter: Router {
    private let tabBar: UITabBarController
    
    init(tabBar: UITabBarController) {
        self.tabBar = tabBar
    }
    
    private(set) weak var viewController: UIViewController!
    
    @discardableResult
    func launch() -> UIViewController {
        let vc = GameListViewController(
            presenter: GameListPresenter(
                interactor: GameListAPIInteractor()
            )
        )
        self.viewController = vc
        
        vc.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "Home"),
            selectedImage: UIImage(named: "Home_fill"))
        tabBar.viewControllers?.append(vc)
        return vc
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
    
    class StubPresenter: IGameListPresenter {}
}
#endif