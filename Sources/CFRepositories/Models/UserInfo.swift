//
//  UserInfo.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 26/01/2024.
//

import Foundation


public struct TokenInfo: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String
}

public struct SignUpInfo: Codable {
    public let meta: MetaData?
    public let data: UserInfo?
    public let pagination: PagingData?
}

public struct MetaData: Codable {
    public let code: Int?
    public let errorMessage: String?
    public let errorType: String?
}

public struct UserInfo: Codable {
    public let email: String
    let firstName: String
    let lastName: String
    let username: String
    let userImageLink: String
    let emailConfirmed: Bool
    let numberOfShares: Int
    let numberOfFavourites: Int
    let phoneNumberConfirmed: Bool
    let phoneNumber: String
    let registeredOn: String
    let allowLogin: Bool
    let enablePushNotifications: Bool
}

public struct PagingData: Codable {
    var pageSize: Int?
    let totalRecords: Int?
    let isLastSet: Bool?
}
