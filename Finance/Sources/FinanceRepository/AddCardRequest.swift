//
//  AddCardRequest.swift
//  
//
//  Created by a60105114 on 2022/01/10.
//

import Foundation
import Network
import FinanceEntity

struct AddCardRequest: Request {
    typealias Output = AddCardResponse
    
    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeader
    
    init(
        baseUrl: URL,
        info: AddPaymentMethodInfo
    ) {
        self.endpoint = baseUrl.appendingPathComponent("/addCard")
        self.method = .post
        self.query = [
            "number" : info.number,
            "cvc" : info.cvc,
            "expiration" : info.expiration
        ]
        self.header = [:]
    }
}

struct AddCardResponse: Decodable {
    let card: PaymentModel
}
