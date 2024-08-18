//
//  UserInfoViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import UIKit

class UserInfoViewController: UIViewController {

    private var follower: Follower

    init(follower: Follower) {
        self.follower = follower
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavBar()
        addViews()
        layoutConstraints()
    }

    private func configureNavBar() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func addViews() {
        
    }

    private func layoutConstraints() {

    }

    @objc
    private func dismissVC() {
        dismiss(animated: true)
    }
}
