//
//  File.swift
//  
//
//  Created by 장용범 on 2022/01/30.
//

import Foundation
import FinanceRepository
import Combine
import CombineUtil
import FinanceEntity

public final class CardOnFileRepositoryMock: CardOnFileRepository {
    public var cardOnFileSubject: CurrentValuePublisher<[PaymentModel]> = .init([])
    
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentModel]> {
        cardOnFileSubject
    }
    
    var addCardCallCount = 0
    var addCardInfo: AddPaymentMethodInfo?
    var addedPaymentModel: PaymentModel?
    public func addCard(_ info: AddPaymentMethodInfo) -> AnyPublisher<PaymentModel, Error> {
        addCardCallCount += 1
        addCardInfo = info
        
        if let addedPaymentModel = addedPaymentModel {
            return Just(addedPaymentModel).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "CardOnFileRepositoryMock", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
    }
    
    var fetchCallCount = 0
    public func fetch() {
        fetchCallCount += 1
    }
    
    public init() { }
    
}
