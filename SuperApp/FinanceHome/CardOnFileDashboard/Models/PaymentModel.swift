//
//  PaymentModel.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/24.
//

import Foundation

struct PaymentModel: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
