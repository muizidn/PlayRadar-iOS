//
//  Pagination.swift
//  PlayRadar
//
//  Created by Muhammad Muizzsuddin on 09/08/23.
//

import Foundation

struct Pagination<T> {
    let data: [T]
    let page: Int
    let count: Int
}
