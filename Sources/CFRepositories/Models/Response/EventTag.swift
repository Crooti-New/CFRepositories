//
//  File.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 12/02/2024.
//

import Foundation

public struct EventTag: Codable {
    let tagId : String
    let title : String
    let imageUrl : String
    var isSelected : Bool?
}
