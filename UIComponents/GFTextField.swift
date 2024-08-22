//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor

        textColor = .label
        tintColor = .label
        textAlignment = .center

        placeholder = "Enter a username"
        backgroundColor = .tertiarySystemBackground
        font = UIFont.preferredFont(forTextStyle: .title2)

        // If user has a really long username, shrink that to kinda fit inside the frames.
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12

        autocorrectionType = .no
        keyboardType = .default
        returnKeyType = .go

        // To get a little cross button while typing
        clearButtonMode = .whileEditing
    }
}
