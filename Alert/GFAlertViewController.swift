//
//  GFAlertViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

class GFAlertViewController: UIViewController {

    var alertTitle: String?
    var alertDesc: String?
    var alertButton: String?

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()

    private var titleLabel = GFTitleLabel(textAlignment: .center, fontSize: 20)
    private var descLabel = GFBodyLabel(textAlignment: .center)
    private var actionButton = GFButton(backgroundColor: .systemPink, title: "Default Action")

    init(alertTitle: String? = nil, alertDesc: String? = nil, alertButton: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.alertDesc = alertDesc
        self.alertButton = alertButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        addViews()
        configure()
        layoutConstraints()
    }

    private func addViews() {
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.cgColor

        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, descLabel, actionButton)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 230),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            descLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        ])
    }

    private func configure() {
        titleLabel.text = alertTitle ?? "Default Title"
        descLabel.text = alertDesc ?? "Default Description"
        descLabel.numberOfLines = 0
        actionButton.setTitle(alertButton ?? "Default Button", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
    }

    @objc
    private func dismissAlert() {
        dismiss(animated: true)
    }
}
