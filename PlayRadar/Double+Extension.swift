//
//  Double+Extension.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation

public extension Double {
    var hasFractionalPart: Bool {
        return self != Double(Int(self))
    }
}
