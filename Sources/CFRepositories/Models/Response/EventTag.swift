//
//  File.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 12/02/2024.
//

import Foundation

public struct EventTag: Codable, Hashable {
    let tagId : String
    public let title : String
    let image : String
    var isSelected : Bool?
}
