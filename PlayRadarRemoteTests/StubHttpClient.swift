//
//  StubHttpClient.swift
//  PlayRadarRemoteTests
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation
@testable import PlayRadarRemote

final class StubHttpClient: HTTPClient {
    var requestResponse: (Data, HTTPStatus)!
    func performRequest(_ request: URLRequest) async throws -> (Data, HTTPStatus) {
        return requestResponse
    }
}
