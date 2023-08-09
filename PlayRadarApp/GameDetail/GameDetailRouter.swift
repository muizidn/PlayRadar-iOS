//
//  GameDetailRouter.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit
import PlayRadar

final class GameDetailRouter: Router {
    private var vc: GameDetailViewController!
    
    @discardableResult
    func launch() -> UIViewController {
        vc = GameDetailViewController()
        return vc
    }
}

#if DEBUG
import SwiftUI

struct GameDetailRouter_Previews: PreviewProvider {
    static var previews: some View {
        RouterPreviewContainer {
            GameDetailRouter()
        }
    }
}
#endif
