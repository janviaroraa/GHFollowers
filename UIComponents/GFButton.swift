//
//  GFButton.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

class GFButton: UIButton {

    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        set(backgroundColor: backgroundColor, title: title)
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

// Updated after 15.0
// New buttons have built-in corner-radius
class GFButtonUpdated: UIButton {

    convenience init(color: UIColor, title: String, imageName: String) {
        self.init(frame: .zero)
        set(color: color, title: title, imageName: imageName)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }

    func set(color: UIColor, title: String, imageName: String) {
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
        configuration?.title = title

        configuration?.image = UIImage(systemName: imageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading  // Default
    }
}
