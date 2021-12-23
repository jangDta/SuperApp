//
//  AppHomeViewController.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/22.
//

import ModernRIBs
import UIKit

protocol AppHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AppHomeViewController: UIViewController, AppHomePresentable, AppHomeViewControllable {
    
    weak var listener: AppHomePresentableListener?
    
    private let widgetStackView: UIStackView = {
      let stackView = UIStackView()
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.axis = .horizontal
      stackView.distribution = .fillEqually
      stackView.alignment = .top
      stackView.spacing = 20
      return stackView
    }()
    
    init() {
      super.init(nibName: nil, bundle: nil)
      setupViews()
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
      setupViews()
    }
    
    private func setupViews() {
        title = "홈"
        tabBarItem = UITabBarItem(
            title: "홈",
            image: .init(systemName: "house"),
            selectedImage: .init(systemName: "house.fill")
        )
        view.backgroundColor = .systemBackground
        view.addSubview(widgetStackView)
        
        NSLayoutConstraint.activate([
            widgetStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            widgetStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            widgetStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func updateWidget(_ viewModels: [HomeWidgetViewModel]) {
        viewModels
            .map {
                HomeWidgetView(viewModel: $0)
            }
            .forEach {
                $0.addShadowWithRoundedCorners(12)
                widgetStackView.addArrangedSubview($0)
            }
    }
}
