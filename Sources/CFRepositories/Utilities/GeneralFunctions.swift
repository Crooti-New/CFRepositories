//
//  GeneralFunctions.swift
//  Crooti

import Foundation
import UIKit

class GeneralFunctions {
    
    static func convertArabicNumbersToEnglish(value: String) -> String {
        let newValue = value
            .replacingOccurrences(of: "١", with: "1")
            .replacingOccurrences(of: "٢", with: "2")
            .replacingOccurrences(of: "٣", with: "3")
            .replacingOccurrences(of: "٤", with: "4")
            .replacingOccurrences(of: "٥", with: "5")
            .replacingOccurrences(of: "٦", with: "6")
            .replacingOccurrences(of: "٧", with: "7")
            .replacingOccurrences(of: "٨", with: "8")
            .replacingOccurrences(of: "٩", with: "9")
            .replacingOccurrences(of: "٠", with: "0")
            .replacingOccurrences(of: "،", with: ".")
            .replacingOccurrences(of: "٫", with: ".")
        
        return newValue
    }
    
    static func trimLeadingZeroes(input: String) -> String {
        var result = ""
        for character in input {
            if result.isEmpty && character == "0" { continue }
            result.append(character)
        }
        return result
    }
    
    static func getDeviceType() -> String{
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            return "iPhone 4"
        } else if DeviceType.IS_IPHONE_6 {
            return "iPhone 6"
        } else if DeviceType.IS_IPHONE_6P {
            return "iPhone 5"
        } else if DeviceType.IS_IPHONE_7 {
            return "iPhone 7"
        } else if DeviceType.IS_IPHONE_7P {
            return "iPhone 7 Plus"
        } else {
            return ""
        }
    }
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE            = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_7          = IS_IPHONE_6
    static let IS_IPHONE_7P         = IS_IPHONE_6P
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO_9_7      = IS_IPAD
    static let IS_IPAD_PRO_12_9     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}
