//
//  APIResponseBase.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation

struct APIResponseBase<T: Codable>: Codable {
    let next: String?
    let results: T
}
