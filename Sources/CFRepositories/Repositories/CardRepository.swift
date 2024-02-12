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
    func getSharedCards() async throws -> [SharedCard]
    func getReceivedCards() async throws -> [ReceivedCard]
    func getEventCards() async throws -> [Event]
    func getEventDetail(eventId: String) async throws -> (tags:  [EventTag], cards: [EventCard])
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
    func getReceivedCards() async throws -> [ReceivedCard] {
        let result = try await execute(endpoint: API.getReceivedCards, logLevel: .debug)
        let json = try? JSON(data: result.data)
        
        if let meta: MetaData = MetaData.metaFromJson(json: json?["meta"]) {
            if meta.code == 200 {
                if let cards = json?["data"]["recievedCards"].prettyJSONString {
                    let parsedCards: [ReceivedCard] = try JSONDecoder().decode([ReceivedCard].self, from: cards.data(using: String.Encoding.utf8.rawValue)!)
                    return parsedCards
                }
            } else {
                throw NSError(domain: meta.errorType ?? "", code: meta.code ?? 400, userInfo: [NSLocalizedDescriptionKey: meta.errorMessage ?? ""])
            }
        }
        throw NSError(domain: "-1", code: -1, userInfo: nil)
    }
    
    func getSharedCards() async throws -> [SharedCard] {
        let result = try await execute(endpoint: API.getSharedCards, logLevel: .debug)
        let json = try? JSON(data: result.data)
        
        if let meta: MetaData = MetaData.metaFromJson(json: json?["meta"]) {
            if meta.code == 200 {
                if let cards = json?["data"]["sharedCards"].prettyJSONString {
                    let parsedCards: [SharedCard] = try JSONDecoder().decode([SharedCard].self, from: cards.data(using: String.Encoding.utf8.rawValue)!)
                    return parsedCards
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
    
    func getEventCards() async throws -> [Event] {
        let result = try await execute(endpoint: API.getEventCards, logLevel: .debug)
        let json = try? JSON(data: result.data)
        if let meta: MetaData = MetaData.metaFromJson(json: json?["meta"]) {
            if meta.code == 200 {
                if let events = json?["data"]["events"].prettyJSONString {
                    let eventsData: [Event] = try JSONDecoder().decode([Event].self, from: events.data(using: String.Encoding.utf8.rawValue)!)
                    return eventsData
                }
            } else {
                throw NSError(domain: meta.errorType ?? "", code: meta.code ?? 400, userInfo: [NSLocalizedDescriptionKey: meta.errorMessage ?? ""])
            }
        }
        throw NSError(domain: "-1", code: -1, userInfo: nil)
    }
    
    func getEventDetail(eventId: String) async throws -> (tags: [EventTag], cards: [EventCard]) {
        let result = try await execute(endpoint: API.getEventDetail(eventId: eventId), logLevel: .debug)
        let json = try? JSON(data: result.data)
        if let meta: MetaData = MetaData.metaFromJson(json: json?["meta"]) {
            if meta.code == 200 {
                if let cards = json?["data"]["backgrounds"].prettyJSONString,
                    let tags =  json?["data"]["tags"].prettyJSONString {
                    let cardsData: [EventCard] = try JSONDecoder().decode([EventCard].self, from: cards.data(using: String.Encoding.utf8.rawValue)!)
                    let tagsData: [EventTag] = try JSONDecoder().decode([EventTag].self, from: tags.data(using: String.Encoding.utf8.rawValue)!)
                    return (tags: tagsData, cards: cardsData)
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
        case getEventCards
        case getEventDetail(eventId: String)
        
        var endPoint: Endpoint {
            switch self {
            case .getHomeCard:
                return .get(path: "/background/home")
            case .getSharedCards:
                return .get(path: "/account/getSharedCards?pageNumber=1")
            case .getReceivedCards:
                return .get(path: "/account/getRecievedCards?pageNumber=1")
            case .getEventCards:
                return .get(path: "/event/list")
            case .getEventDetail(let eventId):
                return .get(path: "/background/\(eventId)")
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .getHomeCard, .getSharedCards, .getReceivedCards, .getEventCards, .getEventDetail(_):
                return .requestParameters(encoding: .urlEncodingGET, urlParameters: nil)
            }
        }
        
        var headers: HTTPHeaders? {
            return authHeader
        }
    }
}

#endif
