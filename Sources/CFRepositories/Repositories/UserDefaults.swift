//
//  UserDefaults.swift
//  Crooti-New
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 30/01/2024.
//

import Foundation
import CFRepositories
import SwiftUI
import UIKit

public enum UserDefaultKey: String {
    case userTokenInfo = "userTokenInfo"
    case userInfo = "userInfo"
}

public struct UserDefaultHandler {
    static let udStandard = UserDefaults.standard
    var userTokenInfo: TokenInfo? {
        get {
            UserDefaults.standard.codableObject(dataType: TokenInfo.self, key: UserDefaultKey.userTokenInfo.rawValue)
        }
        set {
            UserDefaults.standard.setCodableObject(newValue, forKey: UserDefaultKey.userTokenInfo.rawValue)
        }
    }
    
    var userInfo: UserInfo? {
        get {
            UserDefaults.standard.codableObject(dataType: UserInfo.self, key: UserDefaultKey.userInfo.rawValue)
        }
        set {
            UserDefaults.standard.setCodableObject(newValue, forKey: UserDefaultKey.userInfo.rawValue)
        }
    }
}
