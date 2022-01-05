//
//  Reusable.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import Foundation

public protocol Reusable: AnyObject {
  static var reuseIdentifier: String { get }
}

public extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
