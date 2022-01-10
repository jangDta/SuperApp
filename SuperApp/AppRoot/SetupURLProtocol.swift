//
//  SetupURLProtocol.swift
//  SuperApp
//
//  Created by a60105114 on 2022/01/05.
//

import Foundation
import FinanceRepository

func setupURLProtocol() {
    // topup
    let topupResponse: [String: Any] = [
        "status" : "success"
    ]
    
    let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
    
    // addCard
    let addCardResponse: [String: Any] = [
        "card" : [
            "id" : "999",
            "name" : "새 카드",
            "digits" : "9999",
            "color" : "",
            "isPrimary" : false
        ]
    ]
    
    let addCardResponseData = try! JSONSerialization.data(withJSONObject: addCardResponse, options: [])
    
    SuperAppURLProtocol.successMock = [
        "/api/topup" : (200, topupResponseData),
        "/api/addCard" : (200, addCardResponseData),
    ]
}
