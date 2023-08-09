//
//  DashboardViewController.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import UIKit

class DashboardViewController: UITabBarController {

    private let gameList = GameListViewController()
    private let favoriteList = FavoriteGameListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameList.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "Home"),
            selectedImage: UIImage(named: "Home_fill"))
        favoriteList.tabBarItem = UITabBarItem(
            title: "Favorite",
            image: UIImage(named: "Favorite"),
            selectedImage: UIImage(named: "Favorite_fill"))
        
        viewControllers = [
            gameList,
            favoriteList
        ]
    }
    
}


#if DEBUG
import SwiftUI

struct DashboardViewController_Previews: PreviewProvider {
    static var previews: some View {
        ControllerPreviewContainer {
            let vc = DashboardViewController()
            vc.viewDidLoad()
            return vc
        }
    }
}
#endif
