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
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    @discardableResult
    func launch() -> UIViewController {
        vc = GameDetailViewController()
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
            PushGameDetailRouter(navigationController: nav)
                .launch()
            return nav
        }
    }
}
#endif