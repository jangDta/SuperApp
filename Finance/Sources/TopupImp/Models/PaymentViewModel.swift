//
//  PaymentViewModel.swift
//  SuperApp
//
//  Created by a60105114 on 2022/01/04.
//

import UIKit
import FinanceEntity

public struct PaymentViewModel {
    let name: String
    let digits: String
    let color: UIColor
    
    public init(_ model: PaymentModel) {
        self.name = model.name
        self.digits = model.digits
        self.color = UIColor.random
    }
}
