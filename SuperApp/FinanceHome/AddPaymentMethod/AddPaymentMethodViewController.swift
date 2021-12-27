//
//  AddPaymentMethodViewController.swift
//  SuperApp
//
//  Created by 장용범 on 2021/12/26.
//

import ModernRIBs
import UIKit

protocol AddPaymentMethodPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didTapClose()
    func didConfirm(number: String, cvc: String, expiration: String)
}

final class AddPaymentMethodViewController: UIViewController, AddPaymentMethodPresentable, AddPaymentMethodViewControllable {
    
    weak var listener: AddPaymentMethodPresentableListener?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 14
        return stackView
    }()
    
    private let cardNumberTextField: UITextField = {
        let textField = makeTextField()
        textField.placeholder = "카드번호"
        return textField
    }()
    
    private let cvcTextField: UITextField = {
        let textField = makeTextField()
        textField.placeholder = "CVC"
        return textField
    }()
    
    private let expirationTextField: UITextField = {
        let textField = makeTextField()
        textField.placeholder = "유효기간"
        return textField
    }()
    
    private lazy var addCardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.roundCorners()
        button.setTitle("추가하기", for: .normal)
        button.addTarget(self, action: #selector(didTapAddCard), for: .touchUpInside)
        return button
    }()
    
    private static func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        return textField
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupViews() {
        title = "카드 추가"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)),
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
        
        view.addSubview(cardNumberTextField)
        view.addSubview(stackView)
        view.addSubview(addCardButton)
        
        stackView.addArrangedSubview(cvcTextField)
        stackView.addArrangedSubview(expirationTextField)
        
        NSLayoutConstraint.activate([
            cardNumberTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            cardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            cardNumberTextField.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            cvcTextField.heightAnchor.constraint(equalToConstant: 60),
            expirationTextField.heightAnchor.constraint(equalToConstant: 60),
            
            addCardButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            addCardButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc
    func didTapAddCard() {
        if let number = cardNumberTextField.text,
           let cvc = cvcTextField.text,
           let expiration = expirationTextField.text {
            listener?.didConfirm(number: number, cvc: cvc, expiration: expiration)
        }
    }
    
    @objc
    func didTapClose() {
        listener?.didTapClose()
    }
}
