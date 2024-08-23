//
//  GFEmptyStateView.swift
//  GHFollowers
//
//  Created by Janvi Arora on 16/08/24.
//

import UIKit

// Reference Account with 0 followers: adarshpandey01
class GFEmptyStateView: UIView {

    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)

    private lazy var logoImageView: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: SFSymbols.emptyState))
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configure()
        addViews()
        layoutConstraints()
    }

    init(message: String) {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        configure()
        addViews()
        layoutConstraints()
        messageLabel.text = message
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .secondaryLabel
    }

    private func addViews() {
        addSubviews(messageLabel, logoImageView)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),

            // making it a square
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.4),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.4),

            logoImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 120),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 230)
        ])
    }
}
