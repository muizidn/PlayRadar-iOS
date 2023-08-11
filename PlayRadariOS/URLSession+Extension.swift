//
//  URLSession+Extension.swift
//  PlayRadariOS
//
//  Created by Muhammad Muizzsuddin on 11/08/23.
//

import Foundation
import PlayRadarRemote

extension URLSession: HTTPClient {
    public func performRequest(_ request: URLRequest) async throws -> (Data, HTTPStatus) {
        let (data, res) = try await data(for: request)
        return (data, (res as! HTTPURLResponse).statusCode >= 400 ? .notFound : .success)
    }
}
