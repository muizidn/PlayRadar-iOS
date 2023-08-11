//
//  WeakProxy.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation

final class WeakProxy<T: NSObject> {
    weak var proxy: T?
    
    init(_ proxy: T) {
        self.proxy = proxy
    }
}
