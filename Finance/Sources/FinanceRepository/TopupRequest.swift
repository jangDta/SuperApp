//
//  TopupRequest.swift
//  
//
//  Created by a60105114 on 2022/01/05.
//

import Foundation
import Network

struct TopupRequest: Request {
    typealias Output = TopupResponse
    
    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeader
    
    init(
        baseUrl: URL,
        amount: Double,
        paymentMethodID: String
    ) {
        self.endpoint = baseUrl.appendingPathComponent("/topup")
        self.method = .post
        self.query = [
            "amount" : amount,
            "paymentMethodID" : paymentMethodID
        ]
        self.header = [:]
    }
}

struct TopupResponse: Decodable {
    let status: String
}
