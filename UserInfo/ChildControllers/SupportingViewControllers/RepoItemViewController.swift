//
//  RepoItemViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import UIKit

class RepoItemViewController: ItemInfoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureItems()
    }

    private func configureItems() {
        itemInfoView1.set(item: .repos, withCount: user.publicRepos ?? 0)
        itemInfoView2.set(item: .gists, withCount: user.publicGists ?? 0)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }

    override func actionButtonTapped() {
        delegate?.didTapProfile(user.htmlUrl)
    }
}
