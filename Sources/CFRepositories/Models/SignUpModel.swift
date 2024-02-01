//
//  SignUpModel.swift
//  Crooti-New
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 27/01/2024.
//

import Foundation

public struct SignUpModel {
    var firstName: String
    var lastName: String
    var password: String
    var email: String
    var phonenumber: String
    var userName: String
    
    public init(firstName: String, lastName: String, password: String, email: String, phonenumber: String, userName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.email = email
        self.phonenumber = phonenumber
        self.userName = userName
    }
    
    public func isValidInfo() -> Bool {
        if self.firstName.isEmpty || self.lastName.isEmpty || self.password.isEmpty  || self.email.isEmpty || self.userName.isEmpty {
            return false
        }
        return true
    }
    
    public func isValidEmail() -> Bool {
        return GeneralFunctions.isValidEmail(emailStr: self.email)
    }
    
    public func isValidPhoneNumber() -> Bool {
        return true
    } 
}

public struct SignUpInfo: Codable {
    public let meta: MetaData?
    public let data: User?
    public let pagination: PagingData?
}

public struct PagingData: Codable {
    var pageSize: Int?
    let totalRecords: Int?
    let isLastSet: Bool?
}
