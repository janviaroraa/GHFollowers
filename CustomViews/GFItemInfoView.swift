//
//  GFItemInfoView.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import UIKit

enum ItemInfoType {
    case repos
    case gists
    case followers
    case following
}

class GFItemInfoView: UIView {

    let symbolImageView = UIImageView()
    let titleLabel = GFTitleLabel(textAlignment: .left, fontSize: 16)
    let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViews() {
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label

        addSubviews(symbolImageView, titleLabel, countLabel)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),

            titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            countLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4)
        ])
    }

    func set(item: ItemInfoType, withCount count: Int) {
        switch item {
        case .repos:
            titleLabel.text = "Public Repos"
            symbolImageView.image = UIImage(systemName: InfoItems.repos)
        case .gists:
            titleLabel.text = "Public Gists"
            symbolImageView.image = UIImage(systemName: InfoItems.gists)
        case .followers:
            titleLabel.text = "Followers"
            symbolImageView.image = UIImage(systemName: InfoItems.followers)
        case .following:
            titleLabel.text = "Following"
            symbolImageView.image = UIImage(systemName: InfoItems.following)
        }
        countLabel.text = String(count)
    }
}
