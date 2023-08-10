//
//  Pagination.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation

public struct Pagination<T> {
    public let data: [T]
    public let page: Int
    public let count: Int
    public let hasNext: Bool
}
