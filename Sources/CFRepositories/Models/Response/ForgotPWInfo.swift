//
//  File.swift
//  
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 03/02/2024.
//

import Foundation

public struct ForgotPWInfo: Codable {
    public let meta: MetaData?
    public let data: ForgotPWData?
    public let pagination: PagingData?
}

public struct ForgotPWData: Codable {
    public let message: String
}
