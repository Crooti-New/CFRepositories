//
//  UserInfo.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 26/01/2024.
//

import Foundation

public struct User: Codable, Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.data?.email == rhs.data?.email
    }
    
    public let meta: MetaData?
    public let data: UserInfo?
    
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
}

