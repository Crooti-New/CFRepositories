//
//  File.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 12/02/2024.
//

import Foundation

public struct Event: Codable, Hashable {
    public let eventId: String
    public let title: String
    public let numberOfCards: Int
    public let image: String
}
