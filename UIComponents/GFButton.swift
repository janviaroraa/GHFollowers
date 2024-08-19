//
//  GFButton.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

class GFButton: UIButton {

    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
        configure()
    }

    override init(frame: CGRect) {
        // In order to give the default frame, we use super.init(frame: )
        // This means we are calling the parent initialization
        // i.e. we are building our GFButton on top of UIButton.
        super.init(frame: frame)
        configure()
    }

    // This func is called when we initialize GFButton via Storyboard. Since we are not using storyboards here, we are just passing a fatalError()
    // However when we are subclassing things from UIKit, we have to handle the storyboard case.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)

        // This says to use AutoLayout when doing UI stuff programatically.
        translatesAutoresizingMaskIntoConstraints = false
    }

    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
