//
//  UserDefaults.swift
//  Crooti-New
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 30/01/2024.
//

import Foundation
import SwiftUI
import UIKit

public enum UserDefaultKey: String {
    case userTokenInfo = "userTokenInfo"
    case userInfo = "userInfo"
    case userSelectedLanguage = "userSelectedLanguage"
    case pushDeviceToken = "pushDeviceToken"
}

public struct UserDefaultHandler {
    static let udStandard = UserDefaults.standard
    static var userTokenInfo: TokenInfo? {
        get {
            UserDefaults.standard.codableObject(dataType: TokenInfo.self, key: UserDefaultKey.userTokenInfo.rawValue)
        }
        set {
            UserDefaults.standard.setCodableObject(newValue, forKey: UserDefaultKey.userTokenInfo.rawValue)
        }
    }
    
    static var userInfo: User? {
        get {
            UserDefaults.standard.codableObject(dataType: User.self, key: UserDefaultKey.userInfo.rawValue)
        }
        set {
            UserDefaults.standard.setCodableObject(newValue, forKey: UserDefaultKey.userInfo.rawValue)
        }
    }
    
    static var userSelectedLanguage: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.userSelectedLanguage.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.userSelectedLanguage.rawValue)
        }
    }
    
    static var pushDeviceToken: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKey.pushDeviceToken.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.pushDeviceToken.rawValue)
        }
    }
}
