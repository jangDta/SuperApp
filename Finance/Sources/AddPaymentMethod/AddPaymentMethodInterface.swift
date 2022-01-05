//
//  File.swift
//  
//
//  Created by a60105114 on 2022/01/05.
//

import Foundation
import ModernRIBs
import RIBsUtil
import FinanceEntity

// MARK: - AddPaymentMethod Buildable

public protocol AddPaymentMethodBuildable: Buildable {
    func build(withListener listener: AddPaymentMethodListener, dismissButtonType: DismissButtonType) -> ViewableRouting
}

// MARK: - AddPaymentMethod Listener

public protocol AddPaymentMethodListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func addPaymentMethodDidTapClose()
    func addPaymentMethodDidAddCard(_ model: PaymentModel)
}
