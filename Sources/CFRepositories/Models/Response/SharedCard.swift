//
//  SharedCard.swift
//
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 08/02/2024.
//

import Foundation

public struct SharedCard: Codable, Hashable, ICard {
    public let thumbnail: String
    public let image: String
    public let numberOfUnread: Bool
    public let sharedOn: String
    public let platformSharedOn: String
    public let eventId: String
    public let users: [SharedUser]
    
    public func getPlatformSharedOn() -> String {
        return platformSharedOn
    }
    
    public func getImage() -> String {
        return image
    }
    
    public func getSharedOn() -> String {
        return formattedSharedOn()
    }

    
    private func formattedSharedOn() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        let date = dateFormatter.date(from: sharedOn)
        if(date == nil) {
            return ""
        }
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        return dateFormatter.string(from: date!)
    }
}

