//
//  XCTestCase+Extension.swift
//  PlayRadariOSUITests
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation
import XCTest

extension XCUIApplication {
    func launch(args  arguments: [String]) {
        launchArguments = arguments
        launch()
    }
}
