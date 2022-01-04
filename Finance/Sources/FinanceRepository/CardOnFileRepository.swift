//
//  CardOnFileRepository.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/24.
//

import Foundation
import Combine
import FinanceEntity
import CombineUtil

public protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentModel]> { get }
    
    func addCard(_ info: AddPaymentMethodInfo) -> AnyPublisher<PaymentModel, Error>
}

public final class CardOnFileRepositoryImpl: CardOnFileRepository {
    
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentModel]> { paymentSubject }
    
    private let paymentSubject = CurrentValuePublisher<[PaymentModel]>([
        PaymentModel(id: "0", name: "신한은행", digits: "1234", color: "#f19a38ff", isPrimary: false),
        PaymentModel(id: "1", name: "국민은행", digits: "5678", color: "#3478f6ff", isPrimary: false),
        PaymentModel(id: "2", name: "우리은행", digits: "1357", color: "#78c5f5ff", isPrimary: false),
    ])
    
    public init() {}
    
    public func addCard(_ info: AddPaymentMethodInfo) -> AnyPublisher<PaymentModel, Error> {
        let model = PaymentModel(id: "", name: "새 카드", digits: String(info.number.suffix(4)), color: "", isPrimary: false)
        
        var new = paymentSubject.value
        new.append(model)
        paymentSubject.send(new)
        
        return Just(model).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
