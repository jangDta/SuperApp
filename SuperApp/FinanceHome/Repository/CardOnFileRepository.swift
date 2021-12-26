//
//  CardOnFileRepository.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/24.
//

import Foundation

protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentModel]> { get }
}

final class CardOnFileRepositoryImpl: CardOnFileRepository {
    
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentModel]> { paymentSubject }
    
    private let paymentSubject = CurrentValuePublisher<[PaymentModel]>([
        PaymentModel(id: "0", name: "신한은행", digits: "1234", color: "#f19a38ff", isPrimary: false),
        PaymentModel(id: "1", name: "국민은행", digits: "5678", color: "#3478f6ff", isPrimary: false),
        PaymentModel(id: "2", name: "우리은행", digits: "1357", color: "#78c5f5ff", isPrimary: false),
        PaymentModel(id: "3", name: "하나은행", digits: "2468", color: "#65c466ff", isPrimary: false),
        PaymentModel(id: "4", name: "카카오뱅크", digits: "9876", color: "#ffcc00ff", isPrimary: false)
    ])
}
