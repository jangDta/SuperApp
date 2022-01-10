//
//  CardOnFileRequest.swift
//  
//
//  Created by a60105114 on 2022/01/10.
//

import Foundation
import Network
import FinanceEntity

struct CardOnFileRequest: Request {
    typealias Output = CardOnFileResponse
    
    let endpoint: URL
    let method: HTTPMethod
    let query: QueryItems
    let header: HTTPHeader
    
    init(
        baseUrl: URL
    ) {
        self.endpoint = baseUrl.appendingPathComponent("/cardOnFile")
        self.method = .get
        self.query = [:]
        self.header = [:]
    }
}

struct CardOnFileResponse: Decodable {
    let cards: [PaymentModel]
}
