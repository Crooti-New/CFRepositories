//
//  File.swift
//  
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 03/02/2024.
//

import Foundation

public struct PagingData: Codable {
    var pageSize: Int?
    let totalRecords: Int?
    let isLastSet: Bool?
}
