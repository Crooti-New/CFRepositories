//
//  SubmitPhoneNumberInfo.swift
//
//
//  Created by Duong Tran Anh Thoai(ThoaiDTA) on 08/02/2024.
//

import Foundation

public struct SubmitPhoneNumberInfo: Codable {
    public let meta: MetaData?
    public let data: String?
    public let pagination: PagingData?
}
