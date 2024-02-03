//
//  File.swift
//  
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 03/02/2024.
//

import Foundation

public struct SignUpInfo: Codable {
    public let meta: MetaData?
    public let data: User.UserInfo?
    public let pagination: PagingData?
}
