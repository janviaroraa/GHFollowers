//
//  FavouritesTableViewCell.swift
//  GHFollowers
//
//  Created by Janvi Arora on 20/08/24.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {

    static let identifier = "FavouritesTableViewCell"

    private var avatarImageView = GFAvatarImageView(frame: .zero)
    private var usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 24)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        addViews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews () {
        contentView.addSubviews(avatarImageView, usernameLabel)
    }

    private func layoutConstraints() {
        let padding: CGFloat = 12

        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),

            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }

    func configure(favourite: Follower) {
        self.usernameLabel.text = favourite.login
        self.avatarImageView.downloadImage(from: favourite.avatarUrl)
    }
}
