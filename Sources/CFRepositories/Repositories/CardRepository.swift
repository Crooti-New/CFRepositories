//
//  CardRepository.swift
//
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 03/02/2024.
//

#if canImport(Combine) && os(iOS)
import Combine
import Foundation
import UIKit

public protocol CardRepository: WebRepository {
    func getHomeCard() async throws -> [HomeCard]
    func getSharedCards() async throws -> [HomeCard]
    func getReceivedCards() async throws -> [HomeCard]
}

struct CardRepositoryImpl {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_auth_queue") // , attributes: .concurrent
    var interceptor: RequestInterceptor?
    
    @Injected var appState: AppStore<AppState>
    
    init(configuration: ServiceConfiguration) {
        self.session = configuration.urlSession
        self.baseURL = configuration.environment.url
        self.interceptor = configuration.interceptor
    }
}

// MARK: - Async impl
extension CardRepositoryImpl: CardRepository {
    func getReceivedCards() async throws -> [HomeCard] {
        let result = try await execute(endpoint: API.getReceivedCards, logLevel: .debug)
        let json = try? JSON(data: result.data)
        
        if let meta: MetaData = MetaData.metaFromJson(json: json?["meta"]) {
            if meta.code == 200 {
                if let homeCards = json?["data"].prettyJSONString {
                    let homeCardData: [HomeCard] = try JSONDecoder().decode([HomeCard].self, from: homeCards.data(using: String.Encoding.utf8.rawValue)!)
                    return homeCardData
                }
            } else {
                throw NSError(domain: meta.errorType ?? "", code: meta.code ?? 400, userInfo: [NSLocalizedDescriptionKey: meta.errorMessage ?? ""])
            }
        }
        throw NSError(domain: "-1", code: -1, userInfo: nil)
    }
    
    func getSharedCards() async throws -> [HomeCard] {
        let result = try await execute(endpoint: API.getSharedCards, logLevel: .debug)
        let json = try? JSON(data: result.data)
        
        if let meta: MetaData = MetaData.metaFromJson(json: json?["meta"]) {
            if meta.code == 200 {
                if let homeCards = json?["data"].prettyJSONString {
                    let homeCardData: [HomeCard] = try JSONDecoder().decode([HomeCard].self, from: homeCards.data(using: String.Encoding.utf8.rawValue)!)
                    return homeCardData
                }
            } else {
                throw NSError(domain: meta.errorType ?? "", code: meta.code ?? 400, userInfo: [NSLocalizedDescriptionKey: meta.errorMessage ?? ""])
            }
        }
        throw NSError(domain: "-1", code: -1, userInfo: nil)
    }
    
    func getHomeCard() async throws -> [HomeCard] {
        let result = try await execute(endpoint: API.getHomeCard, logLevel: .debug)
        let json = try? JSON(data: result.data)
        
        if let meta: MetaData = MetaData.metaFromJson(json: json?["meta"]) {
            if meta.code == 200 {
                if let homeCards = json?["data"]["backgrounds"].prettyJSONString {
                    let homeCardData: [HomeCard] = try JSONDecoder().decode([HomeCard].self, from: homeCards.data(using: String.Encoding.utf8.rawValue)!)
                    return homeCardData
                }
            } else {
                throw NSError(domain: meta.errorType ?? "", code: meta.code ?? 400, userInfo: [NSLocalizedDescriptionKey: meta.errorMessage ?? ""])
            }
        }
        throw NSError(domain: "-1", code: -1, userInfo: nil)
    }
}

// MARK: - Configuration
extension CardRepositoryImpl {
    enum API: ResourceType {
        case getHomeCard
        case getSharedCards
        case getReceivedCards
        
        var endPoint: Endpoint {
            switch self {
            case .getHomeCard:
                return .get(path: "/background/home")
            case .getSharedCards:
                return .get(path: "/account/getSharedCards?pageNumber=1")
            case .getReceivedCards:
                return .get(path: "/account/getRecievedCards?pageNumber=1")
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .getHomeCard:
                return .requestParameters(encoding: .urlEncodingGET, urlParameters: nil)
            case .getSharedCards:
                return .requestParameters(encoding: .urlEncodingGET, urlParameters: nil)
            case .getReceivedCards:
                return .requestParameters(encoding: .urlEncodingGET, urlParameters: nil)
            }
        }
        
        var headers: HTTPHeaders? {
            return authHeader
        }
    }
}

#endif
