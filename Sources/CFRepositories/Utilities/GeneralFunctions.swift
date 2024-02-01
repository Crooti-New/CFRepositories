//
//  GeneralFunctions.swift
//  Crooti
//
//  Created by Bassel Chaitani on 5/21/17.
//  Copyright © 2017 Bassel Chaitani. All rights reserved.
//

import Foundation

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
    
    static func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
}
