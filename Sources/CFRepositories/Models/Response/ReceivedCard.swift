//
//  File.swift
//  
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 08/02/2024.
//

import Foundation

public struct ReceivedCard: Codable, Hashable {
    public let platformSharedOn: String
    public let sharedOn: String
    public let image: String
    public let thumbnail: String
    public let phoneNumber: String
    public let name: String
}
