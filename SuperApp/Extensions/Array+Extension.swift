//
//  Array+Extension.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
