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
    
    // fetch cardOnFile
    let cardOnFileResponse: [String: Any] = [
        "cards" : [
            [
                "id" : "0",
                "name" : "신한은행",
                "digits" : "1234",
                "color" : "#f19a38ff",
                "isPrimary" : false
            ],
            [
                "id" : "1",
                "name" : "국민은행",
                "digits" : "5678",
                "color" : "#3478f6ff",
                "isPrimary" : false
            ],
            [
                "id" : "2",
                "name" : "우리은행",
                "digits" : "1357",
                "color" : "#78c5f5ff",
                "isPrimary" : false
            ],
        ]
    ]
    
    let cardOnFileResponseData = try! JSONSerialization.data(withJSONObject: cardOnFileResponse, options: [])
    
    SuperAppURLProtocol.successMock = [
        "/api/topup" : (200, topupResponseData),
        "/api/addCard" : (200, addCardResponseData),
        "/api/cardOnFile" : (200, cardOnFileResponseData),
    ]
}
