//
//  GFSecondaryTitleLabel.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import UIKit

class GFSecondaryTitleLabel: UILabel {

    init(fontSize: CGFloat) {
        super.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.90    // 90%
        lineBreakMode = .byTruncatingTail
    }
}
