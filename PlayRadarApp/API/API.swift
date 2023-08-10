//
//  API.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation

private let API_KEY = "bc8695c155c04d66a43de2771f070b54"

enum API {
    case games(page: Int, count: Int)
    case search(query: String)
    case detail(id: String)
    
    var method: String {
        switch self {
        case .games, .search:
            return "GET"
        case .detail:
            return "POST"
        }
    }
    
    var base: String {
        return "https://api.rawg.io/api"
    }
    
    var endpoint: String {
        switch self {
        case .games, .search:
            return "/games"
        case .detail(let id):
            return "/games/\(id)"
        }
    }
    
    var body: Data? {
        return nil
    }
    
    var parameters: [String:Any] {
        switch self {
        case .games(let page, let count):
            return [
                "page": page,
                "page_size": count
            ]
        case .search(let query):
            return [
                "query": query
            ]
        case .detail:
            return [:]
        }
    }
    
    func createUrlRequest() -> URLRequest {
        
        var component = URLComponents(string: base + endpoint)
        
        component?.queryItems = parameters.map({ pair in
            URLQueryItem(name: pair.key, value: "\(pair.value)")
        })
        component?.queryItems?.append(URLQueryItem(name: "key", value: API_KEY))
        
        var urlReq = URLRequest(url: component!.url!)
        
        urlReq.httpMethod = method
        urlReq.httpBody = body
        
        return urlReq
    }
}

