//
//  File.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 12/02/2024.
//

import Foundation

public struct EventCard: Codable, Hashable {
    let backgroundId : String
    public let image : String
    public let numberOfShares : Int
    public let tagIds : [String]
}
