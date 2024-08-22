//
//  RepoItemViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import UIKit

protocol RepoItemDelegate: AnyObject {
    func didTapProfile(_ user: String?)
}

class RepoItemViewController: ItemInfoViewController {

    weak var delegate: RepoItemDelegate?

    init(user: User, delegate: RepoItemDelegate? = nil) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

        // Here, we can also do:
        // delegate?.didTapGetFollowers()

        // Now, this should not happen because we don't have any button to get followers. Also, RepoItemViewController should not have access to didTapGetFollowers() as well.

        // So, we can make protocols inside subclasses i.e. in RepoItemViewController & FollowerItemViewController, instead of super-class ItemInfoViewController
    }
}
