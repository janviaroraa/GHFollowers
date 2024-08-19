//
//  ItemInfoViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import UIKit

protocol ItemInfoDelegate: AnyObject {
    func didTapProfile(_ user: String?)
    func didTapGetFollowers()
}

class ItemInfoViewController: UIViewController {

    var user: User
    weak var delegate: ItemInfoDelegate?

    let stackView = UIStackView()
    let itemInfoView1 = GFItemInfoView()
    let itemInfoView2 = GFItemInfoView()
    let actionButton = GFButton()

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        layoutConstraints()

        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 16
    }

    private func addViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing

        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        view.addSubviews(stackView, actionButton)
        stackView.addArrangedSubview(itemInfoView1)
        stackView.addArrangedSubview(itemInfoView2)
    }

    private func layoutConstraints() {
        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),

            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc
    func actionButtonTapped() { }
    
}
