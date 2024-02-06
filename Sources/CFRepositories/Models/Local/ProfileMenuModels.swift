//
//  File.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 06/02/2024.
//

import Foundation


public struct ProfileMenuSection {
    public let title: String
    public let items: [MenuSectionItem]
}

public struct ProfileMenuSectionItem {
    public var title: String
    public var badgeData: String?
    
    public init(title: String, badgeData: String? = nil) {
        self.title = title
        self.badgeData = badgeData
    }
}


public enum MenuSection: String, Equatable {
    case notifications = "notifications"
    case crootiization = "crooti_ization"
    case account = "account"
    case logout = "logout"
    
    public func value() -> ProfileMenuSection {
        var items: [MenuSectionItem] = []
        switch self {
        case .notifications:
            items = [.notifications]
        case .crootiization:
            items = [.showBorder, .bringLayer]
        case .account:
            items = [.changeLanguage, .changeCellPhone, .changeUserName, .changePassword, .inviteFriends]
        case .logout:
            items = [.deleteAccount, .logOut]
        }
        
        return ProfileMenuSection(title: rawValue, items: items)
    }
}

public enum MenuSectionItem: String, Identifiable {
    public var id: String { rawValue }
    
    case notifications = "notifications"
    
    case showBorder = "show_borders"
    case bringLayer = "bring_layer"
    
    case changeLanguage = "language"
    case changeCellPhone = "change_cellPhone"
    case changeUserName =  "change_userName"
    case changePassword = "change_password"
    case inviteFriends = "invite_friend"
    case deleteAccount = "delete_account"
    case logOut = "logout"
    
    public var value: ProfileMenuSectionItem {
        switch self {
        case .inviteFriends:
            return ProfileMenuSectionItem(title: rawValue)
//            return ProfileMenuSectionItem(title: rawValue, badgeData: "Get $10 credit")
        default:
           return ProfileMenuSectionItem(title: rawValue)
        }
    }
}

public enum Language: String, CaseIterable {
    case english = "English"
    case arab = "Arab"
    
    public var code: String {
        switch self {
        case .english:
            return "en"
        case .arab:
            return "ar"
        }
    }
}
