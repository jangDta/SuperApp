//
//  TopupMock.swift
//  
//
//  Created by 장용범 on 2022/01/30.
//

import Foundation
import FinanceRepository
import FinanceRepositoryTestSupport
import CombineUtil
import FinanceEntity
@testable import TopupImp

final class TopupDependencyMock: TopupInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository = CardOnFileRepositoryMock()
    
    var selectedPaymentStream: CurrentValuePublisher<PaymentModel> = .init(
    PaymentModel(id: "", name: "", digits: "", color: "", isPrimary: false)
    )
    
    
}
