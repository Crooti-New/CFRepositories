//
//  File.swift
//  
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 03/02/2024.
//

import Foundation

public struct TokenInfo: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String
}
