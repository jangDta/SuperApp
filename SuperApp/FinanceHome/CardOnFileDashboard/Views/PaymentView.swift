//
//  PaymentView.swift
//  SuperApp
//
//  Created by a60105114 on 2021/12/24.
//

import UIKit

struct PaymentViewModel {
    let name: String
    let digits: String
    let color: UIColor
    
    init(_ model: PaymentModel) {
        self.name = model.name
        self.digits = model.digits
        self.color = UIColor.random
    }
}

final class PaymentView: UIView {
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(nameLabel)
        addSubview(infoLabel)
        backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
