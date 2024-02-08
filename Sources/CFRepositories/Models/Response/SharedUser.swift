//
//  File.swift
//  
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 08/02/2024.
//

import Foundation

public struct SharedUser: Codable, Hashable {
    public let name: String
    public let userId: String
    public let phoneNumber: String
}
