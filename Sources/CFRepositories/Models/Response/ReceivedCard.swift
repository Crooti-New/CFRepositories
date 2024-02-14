//
//  File.swift
//  
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 08/02/2024.
//

import Foundation

public struct ReceivedCard: Codable, Hashable, ICard {
    public let platformSharedOn: String
    public let sharedOn: String
    public let image: String
    public let thumbnail: String
    public let phoneNumber: String
    public let name: String
    
    public func getPlatformSharedOn() -> String {
        return self.platformSharedOn
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
