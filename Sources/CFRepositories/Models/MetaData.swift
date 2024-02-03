//
//  File.swift
//  
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 02/02/2024.
//

import Foundation

public struct MetaData: Codable {
    public let code: Int?
    public let errorMessage: String?
    public let errorType: String?
    
    static func metaFromJson(json: JSON?) -> MetaData? {
        let code            = json?["code"].int
        let errorMessage          = json?["errorMessage"].string
        var errorType    = json?["errorType"].string
        
        guard code != nil else { return nil }
        return MetaData(code: code, errorMessage: errorMessage, errorType: errorType)
    }
}
