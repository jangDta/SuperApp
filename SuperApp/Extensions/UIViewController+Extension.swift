//
//  UIViewController+Extension.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import UIKit

extension UIViewController {
    func setNavigtaionItem(target: Any?, action: Selector?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
            style: .plain,
            target: target,
            action: action
        )
    }
}
