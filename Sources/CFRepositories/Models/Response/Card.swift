//
//  File.swift
//  
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 14/02/2024.
//

import Foundation

public protocol ICard {
    func getPlatformSharedOn() -> String
    func getImage() -> String
    func getSharedOn() -> String
}
