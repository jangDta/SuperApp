//
//  EnterAmountViewController.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/27.
//

import ModernRIBs
import UIKit

protocol EnterAmountPresentableListener: AnyObject {
    func didTapClose()
    func didTapPaymentMethod()
    func didTapTopup(with amount: Double)
}

final class EnterAmountViewController: UIViewController, EnterAmountPresentable, EnterAmountViewControllable {
    
    weak var listener: EnterAmountPresentableListener?
    
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel) {
        selectedPaymentMethodView.update(with: viewModel)
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        ctaButton.isEnabled = false
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        ctaButton.isEnabled = true
    }
    
    private lazy var selectedPaymentMethodView: SelectedPaymentMethodView = {
        let view = SelectedPaymentMethodView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadowWithRoundedCorners()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPaymentMethod))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private let enterAmountWidget: EnterAmountWidget = {
        let widget = EnterAmountWidget()
        widget.translatesAutoresizingMaskIntoConstraints = false
        widget.addShadowWithRoundedCorners()
        return widget
    }()
    
    private lazy var ctaButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.roundCorners()
        button.setTitle("충전", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.setBackgroundImage(UIColor.systemRed.image(), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapCTAButton), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .medium)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        activity.stopAnimating()
        return activity
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
        title = "충전하기"
        view.backgroundColor = .systemBackground
        
        setNavigtaionItem(target: self, action: #selector(didTapClose))
        
        view.addSubview(selectedPaymentMethodView)
        view.addSubview(enterAmountWidget)
        view.addSubview(ctaButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            selectedPaymentMethodView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            selectedPaymentMethodView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            selectedPaymentMethodView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            selectedPaymentMethodView.heightAnchor.constraint(equalToConstant: 70),
            
            enterAmountWidget.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            enterAmountWidget.topAnchor.constraint(equalTo: selectedPaymentMethodView.bottomAnchor, constant: 20),
            enterAmountWidget.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            ctaButton.heightAnchor.constraint(equalToConstant: 60),
            ctaButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ctaButton.topAnchor.constraint(equalTo: enterAmountWidget.bottomAnchor, constant: 40),
            ctaButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: ctaButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: ctaButton.centerYAnchor),
        ])
    }
    
    @objc
    private func didTapClose() {
        listener?.didTapClose()
    }
    
    @objc
    private func didTapCTAButton() {
        if let amount = enterAmountWidget.text.flatMap(Double.init) {
            listener?.didTapTopup(with: amount)
        }
    }
    
    @objc
    private func didTapPaymentMethod() {
        listener?.didTapPaymentMethod()
    }
}
