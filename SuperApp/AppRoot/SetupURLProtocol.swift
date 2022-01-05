//
//  SetupURLProtocol.swift
//  SuperApp
//
//  Created by a60105114 on 2022/01/05.
//

import Foundation
import FinanceRepository

func setupURLProtocol() {
    let topupResponse: [String: Any] = [
        "status" : "success"
    ]
    
    let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
    
    SuperAppURLProtocol.successMock = [
        "/api/topup" : (200, topupResponseData)
    ]
}
