//
//  FinanceHomeViewController.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/23.
//

import ModernRIBs
import UIKit

protocol FinanceHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class FinanceHomeViewController: UIViewController, FinanceHomePresentable, FinanceHomeViewControllable {

    weak var listener: FinanceHomePresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        title = "슈퍼페이"
        tabBarItem = UITabBarItem(
            title: "슈퍼페이",
            image: .init(systemName: "creditcard"),
            selectedImage: .init(systemName: "creditcard")
        )
        view.backgroundColor = .systemBackground
    }
}
