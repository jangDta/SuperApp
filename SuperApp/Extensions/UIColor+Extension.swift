//
//  UIColor+Extension.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/24.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        let rand = CGFloat(drand48())
        return UIColor(red: rand, green: rand, blue: rand, alpha: 1)
    }
}
