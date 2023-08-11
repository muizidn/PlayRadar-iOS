//
//  HTTPClient.swift
//  PlayRadarRemote
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation

public enum HTTPStatus {
    case success
    case notFound
}

public protocol HTTPClient {
    func performRequest(_ request: URLRequest) async throws -> (Data, HTTPStatus)
}
