//
//  FollowersListViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

class FollowersListViewController: UIViewController {

    var username: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getFollowers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func getFollowers() {
        guard let username else { return }
        NetworkManager.shared.getFollowers(for: username, pageNumber: 1) { [weak self] followers, errorMessage in
            guard let followers else {
                self?.presentAlert(
                    title: "Something went wrong!",
                    message: errorMessage ?? "Default Message",
                    buttonTitle: "OK"
                )
                return
            }
        }
    }

}
