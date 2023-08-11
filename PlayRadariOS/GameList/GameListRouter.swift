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
                    remote: RemoteGameListInteractor(httpClient: URLSession.shared),
                    local: CoreDataLocalGameListInteractor(databaseClient: CoreDataDatabase.shared)
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

#if DEBUG
final class UITestingGameListRouter: NSObject, GameListRouter {
    private(set) var viewController: UIViewController!
    let enableNavigation: Bool
    
    init(enableNavigation: Bool) {
        self.enableNavigation = enableNavigation
    }
    
    func launch() -> UIViewController {
        let vc = GameListViewController(
            presenter: GameListPresenter(
                interactor: MockGameListInteractor()
            ),
            router: WeakProxy(self)
        )
        self.viewController = vc
        return UINavigationController(rootViewController: vc)
    }
    
    func launchDetail(game: GameModel) {
        guard enableNavigation else { return }
        let router = UITestingGameDetailRouter(
            navigationController: viewController.navigationController!,
            game: game)
        router.launch()
    }
    
    class MockGameListInteractor: GameListInteractor {
        func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error> {
            return .success(.init(data: [
                .init(id: "1", title: "Game 1", release: Date(timeIntervalSince1970: 0), rating: 1),
                .init(id: "2", title: "Game 2", release: Date(timeIntervalSince1970: 0), rating: 2),
                .init(id: "3", title: "Game 3", release: Date(timeIntervalSince1970: 0), rating: 3)
            ], page: 1, count: 3, hasNext: false))
        }
        
        func searchGames(query: String) async -> Result<[GameModel], Error> {
            fatalError()
        }
    }
}
#endif
