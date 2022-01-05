//
//  Formatter.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/23.
//

import Foundation

public struct Formatter {
    public static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    public init() {}
}
