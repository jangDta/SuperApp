//
//  DismissButtonType.swift
//  
//
//  Created by a60105114 on 2022/01/03.
//

import Foundation

public enum DismissButtonType {
    case back
    case close
    
    public var iconSystemName: String {
        switch self {
            case .back:
                return "chevron.backward"
            case .close:
                return "xmark"
        }
    }
}
