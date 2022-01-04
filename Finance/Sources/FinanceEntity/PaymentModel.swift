//
//  PaymentModel.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/24.
//

import Foundation

public struct PaymentModel: Decodable {
    public let id: String
    public let name: String
    public let digits: String
    public let color: String
    public let isPrimary: Bool
    
    public init(
        id: String,
        name: String,
        digits: String,
        color: String,
        isPrimary: Bool
    ) {
        self.id = id
        self.name = name
        self.digits = digits
        self.color = color
        self.isPrimary = isPrimary
    }
}
