//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import UIKit

protocol UserInfoDelegate: AnyObject {
    func updateFollowers(for username: String?)
}

class UserInfoViewController: UIViewController {

    private var follower: Follower
    weak var delegate: UserInfoDelegate?

    private let headerView = UIView()
    private let item1View = UIView()
    private let item2View = UIView()
    private let dateLabel = GFBodyLabel(textAlignment: .center)

    init(follower: Follower) {
        self.follower = follower
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBar()
        addViews()
        layoutConstraints()
        getUserInfo()
    }

    private func configureNavBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func addViews() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        item1View.translatesAutoresizingMaskIntoConstraints = false
        item2View.translatesAutoresizingMaskIntoConstraints = false

        item1View.layer.cornerRadius = 18
        item1View.backgroundColor = .secondarySystemBackground

        item2View.layer.cornerRadius = 18
        item2View.backgroundColor = .secondarySystemBackground

        view.addSubviews(headerView, item1View, item2View, dateLabel)
    }

    private func layoutConstraints() {
        let padding: CGFloat = 20
        let items = [headerView, item1View, item2View, dateLabel]

        for item in items {
            NSLayoutConstraint.activate([
                item.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
                item.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            item1View.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            item1View.heightAnchor.constraint(equalToConstant: 140),

            item2View.topAnchor.constraint(equalTo: item1View.bottomAnchor, constant: padding),
            item2View.heightAnchor.constraint(equalToConstant: 140),

            dateLabel.topAnchor.constraint(equalTo: item2View.bottomAnchor, constant: padding),
        ])
    }

    private func getUserInfo() {
        guard let username = follower.login else { return }
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configure(with: user)
                }
            case .failure(let error):
                self.presentAlert(
                    title: "Something went wrong!",
                    message: error.rawValue,
                    buttonTitle: "OK"
                )
            }
        }
    }

    private func add(_ childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }

    private func configure(with user: User) {
        self.add(HeaderViewController(user: user), to: self.headerView)

        let repoVC = RepoItemViewController(user: user)
        repoVC.delegate = self
        self.add(repoVC, to: self.item1View)

        let followerVC = FollowerItemViewController(user: user)
        followerVC.delegate = self
        self.add(followerVC, to: self.item2View)

        if let creationDate = user.createdAt {
            self.dateLabel.text = "GitHub since \(creationDate.convertToDisplayFormat())"
        }
    }

    @objc
    private func dismissVC() {
        dismiss(animated: true)
    }
}

extension UserInfoViewController: ItemInfoDelegate {

    func didTapProfile(_ user: String?) {
        guard let user, let url = URL(string: user) else {
            presentAlert(
                title: "Something went wrong!",
                message: "The URL attached to this user is invalid",
                buttonTitle: "Ok"
            )
            return
        }

        presentSafariViewController(url: url)
    }

    func didTapGetFollowers() {
        delegate?.updateFollowers(for: follower.login)
        dismissVC()
    }
}
