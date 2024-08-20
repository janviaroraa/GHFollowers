//
//  FavouritesListViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 11/08/24.
//

import UIKit

class FavouritesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getFavourites()
    }

    private func getFavourites() {
        PersistenceManager.retrieveFavourites { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let favourites):
                for i in favourites {
                    print(i.login)
                }
            case .failure(let error):
                self.presentAlert(
                    title: "Something went wrong!",
                    message: "There's some trouble accessing this github account. Please try again.",
                    buttonTitle: "OK"
                )
            }
        }
    }
}
