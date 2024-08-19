//
//  FollowerItemViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import UIKit

class FollowerItemViewController: ItemInfoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureItems()
    }

    private func configureItems() {
        itemInfoView1.set(item: .followers, withCount: user.followers ?? 0)
        itemInfoView2.set(item: .following, withCount: user.following ?? 0)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }

    override func actionButtonTapped() {
        delegate?.didTapGetFollowers()
    }
}
