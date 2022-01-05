//
//  TransportHomeInterface.swift
//  
//
//  Created by a60105114 on 2022/01/05.
//

import Foundation
import ModernRIBs

// MARK: - TransportHome Buildable

public protocol TransportHomeBuildable: Buildable {
    func build(withListener listener: TransportHomeListener) -> ViewableRouting
}

// MARK: - TransportHome Listener

public protocol TransportHomeListener: AnyObject {
    func transportHomeDidTapClose()
}
