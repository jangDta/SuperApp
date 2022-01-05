//
//  UITableView+Extension.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import UIKit
import FoundationUtil

extension UITableViewCell: Reusable {}

public extension UITableView {
  
  func register<T: UITableViewCell>(cellType: T.Type) {
    self.register(cellType, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
  func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
    guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
      fatalError("Failed to dequeue reusable cell")
    }
    return cell
  }
}
