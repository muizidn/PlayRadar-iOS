//
//  GameListf.swift
//  PlayRadarApp
//
//  Created by Muhammad Muizzsuddin on 10/08/23.
//

import Foundation
import PlayRadar

public final class RemoteGameListInteractor: GameListInteractor {
    private let decoderDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    public init() {}
    public func loadGames(page: Int) async -> Result<Pagination<GameModel>, Error> {
        do {
            let (data, response) = try await URLSession.shared.data(for: API.games(page: page, count: 10).createUrlRequest())
            guard !((response as! HTTPURLResponse).statusCode >= 400) else {
                return .failure(NSError(domain: "\(Self.self)", code: 1, userInfo: [
                    NSLocalizedDescriptionKey: "Not Found"
                ]))
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(decoderDateFormatter)
            
            let resp = try decoder.decode(APIResponseBase<[GameCodable]>.self, from: data)
            return .success(.init(data: resp.results.map({
                GameModel(
                    id: $0.id.description,
                    cover: $0.background_image.flatMap {URL(string: $0)},
                    title: $0.name,
                    release: $0.released ?? Date(),
                    rating: $0.rating
                )
            }), page: page, count: 10, hasNext: resp.next != nil))
        } catch {
            return .failure(error)
        }
    }
    
    public func searchGames(query: String) async -> Result<[GameModel], Error> {
        do {
            let (data, response) = try await URLSession.shared.data(for: API.search(query: query).createUrlRequest())
            guard !((response as! HTTPURLResponse).statusCode >= 400) else {
                return .failure(NSError(domain: "\(Self.self)", code: 1, userInfo: [
                    NSLocalizedDescriptionKey: "Not Found"
                ]))
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(decoderDateFormatter)
            
            let resp = try decoder.decode(APIResponseBase<[GameCodable]>.self, from: data)
            return .success(resp.results.map({
                GameModel(
                    id: $0.id.description,
                    cover: $0.background_image.flatMap {URL(string: $0)},
                    title: $0.name,
                    release: $0.released ?? Date(),
                    rating: $0.rating
                )
            }))
        } catch {
            return .failure(error)
        }
    }
}



fileprivate struct GameCodable: Codable {
    struct Platform: Codable {
        struct PlatformInfo: Codable {
            let id: Int
            let name: String
        }
        
        let platform: PlatformInfo
        let released_at: String?
    }
    
    let id: Int
    let name: String
    let background_image: String?
    let released: Date?
    let rating: Double
    let platforms: [Platform]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, rating, platforms, background_image
    }
}

