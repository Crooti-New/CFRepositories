//
//  File.swift
//  
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 08/02/2024.
//

import Foundation

public struct ChangeUsernameInfo: Codable {
    public let meta: MetaData?
    public let data: String?
    public let pagination: PagingData?
}

public struct ChangeUsernameData: Codable {
    public let message: String
}
