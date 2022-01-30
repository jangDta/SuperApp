//
//  SuperPayRepositoryMock.swift
//  
//
//  Created by a60105114 on 2022/01/28.
//

import Foundation
import FinanceRepository
import CombineUtil
import Combine

public final class SuperPayRepositoryMock: SuperPayRepository {
    
    public var balanceSubject = CurrentValuePublisher<Double>(0)
    
    public var balance: ReadOnlyCurrentValuePublisher<Double> {
        balanceSubject
    }
    
    public var topupCallCount = 0
    public var topupAmount: Double?
    public var topupPaymentMethodID: String?
    public var shouldTopupSucceed: Bool = true
    
    public func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        topupCallCount += 1
        topupAmount = amount
        topupPaymentMethodID = paymentMethodID
        
        if shouldTopupSucceed {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "SuperPayRepositoryMock", code: 0, userInfo: nil)).eraseToAnyPublisher()
        }
    }
    
    public func payRide(amount: Double, paymentMethodId: String) -> AnyPublisher<Void, Error> {
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public init() { }
    
}
