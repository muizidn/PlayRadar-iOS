//
//  DashboardRouter.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit
import PlayRadar

final class DashboardRouter: Router {
    private var vc: DashboardViewController!
    private var gameListRouter: GameListRouter!
    private var favoriteListRouter: FavoriteListRouter!
    
    @discardableResult
    func launch() -> UIViewController {
        vc = DashboardViewController()
        vc.viewDidLoad()
        
        gameListRouter = GameListTabBarChildRouter(tabBar: vc)
        gameListRouter.launch()
        
        favoriteListRouter = FavoriteTabBarChildRouter(tabBar: vc)
        favoriteListRouter.launch()
        
        return vc
    }
}

#if DEBUG
import SwiftUI

struct DashboardRouter_Previews: PreviewProvider {
    static var previews: some View {
        RouterPreviewContainer {
            return DashboardRouter()
        }
    }
}
#endif
