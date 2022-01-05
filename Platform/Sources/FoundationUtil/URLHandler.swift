//
//  URLHandler.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/22.
//

import Foundation

public protocol URLHandler: AnyObject {
    func handle(_ url: URL)
}
