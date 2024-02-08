//
//  SharedCard.swift
//
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 08/02/2024.
//

import Foundation

public struct SharedCard: Codable, Hashable {
    public let thumbnail: String
    public let image: String
    public let numberOfUnread: Bool
    public let sharedOn: String
    public let platformSharedOn: String
    public let eventId: String
    public let users: [SharedUser]
}
