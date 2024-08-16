//
//  FollowersCollectionViewCell.swift
//  GHFollowers
//
//  Created by Janvi Arora on 15/08/24.
//

import UIKit

class FollowersCollectionViewCell: UICollectionViewCell {

    static let identifier = "FollowersCollectionViewCell"

    private var avatarImageView = GFAvatarImageView(frame: .zero)
    private var usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addView()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addView() {
        contentView.addSubviews(avatarImageView, usernameLabel)
    }

    private func layoutConstraints() {
        let padding: CGFloat = 8

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            // Leading & trailing is fixed here, so that gives us the width of our imageView, and we can make our height equal to width, since we want our avatar image view to be a square.
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(follower: Follower) {
        self.usernameLabel.text = follower.login
//        self.avatarImageView.image = UIImage(named: follower.avatarUrl ?? "avatar-placeholder")
    }
}
