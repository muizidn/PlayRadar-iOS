//
//  DashboardViewController.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 08/08/23.
//

import UIKit
import PlayRadar

class DashboardViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
