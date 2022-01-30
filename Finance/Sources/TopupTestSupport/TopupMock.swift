//
//  TopupMock.swift
//  
//
//  Created by 장용범 on 2022/01/30.
//

import Foundation
import Topup

public final class TopupListenerMock: TopupListener {
    var topupDidCloseCallCount = 0
    public func topupDidClose() {
        topupDidCloseCallCount += 1
    }
    
    var topupDidFinishCallCount = 0
    public func topupDidFinish() {
        topupDidFinishCallCount += 1
    }
    
    public init() { }
}
