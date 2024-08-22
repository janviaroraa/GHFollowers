//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }

    func pinToEdges(of superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor),
            leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
