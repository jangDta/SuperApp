//
//  UIColor+Extension.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/24.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}
