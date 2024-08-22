//
//  GFTitleLabel.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

class GFTitleLabel: UILabel {

    // BEFORE
    // init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
    //    super.init(frame: .zero)
    //    self.textAlignment = textAlignment
    //    self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    //    configure()
    //}

    // In order ro avoid calling configure() in both inits, we can make our custom init (above one) a convenience init.
    // convenience init always has to call designated init.

    // AFTER
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }

    // Designated init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9    // 90%
        lineBreakMode = .byTruncatingTail
    }

}
