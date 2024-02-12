//
//  File.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 12/02/2024.
//

import Foundation

public struct EventCard: Codable {
    let cardId : String
    let imageUrl : String
    let numberOfCards : Int
    let tagIds : [String]
}
