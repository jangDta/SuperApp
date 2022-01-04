//
//  UIViewController+Extension.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import UIKit
import RIBsUtil

public extension UIViewController {
    
    func setNavigtaionItem(type: DismissButtonType, target: Any?, action: Selector?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: type.iconSystemName,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
            ),
            style: .plain,
            target: target,
            action: action
        )
    }
}
