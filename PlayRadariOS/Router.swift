//
//  Router.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import UIKit

protocol Router {
    @discardableResult
    func launch() -> UIViewController
}

extension WeakProxy: Router where T: Router {
    func launch() -> UIViewController {
        proxy!.launch()
    }
}

#if DEBUG
class DummyRouterBase: Router {
    func launch() -> UIViewController {
        fatalError()
    }
}
#endif
