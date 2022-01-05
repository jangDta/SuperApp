//
//  TopupInterface.swift
//  
//
//  Created by a60105114 on 2022/01/05.
//

import Foundation
import ModernRIBs

// MARK: - Topup Buildable

public protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> Routing
}

// MARK: - Topup Listener

public protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}
