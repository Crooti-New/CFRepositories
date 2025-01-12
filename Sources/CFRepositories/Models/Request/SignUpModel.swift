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
    public var email: String
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
}

