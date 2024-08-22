//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 11/08/24.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().tintColor = .systemGreen
        setupTabs()
    }

    private func setupTabs() {
        let searchVC = SearchViewController()
        let favouritesVC = FavouritesListViewController()

        searchVC.navigationItem.largeTitleDisplayMode = .automatic
        favouritesVC.navigationItem.largeTitleDisplayMode = .automatic

        searchVC.title = "Search"
        favouritesVC.title = "Favourites"

        let nav1 = UINavigationController(rootViewController: searchVC)
        let nav2 = UINavigationController(rootViewController: favouritesVC)

        nav1.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: Tabs.search), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Favourites", image: UIImage(systemName: Tabs.favourites), tag: 2)

        for nav in [nav1, nav2] {
            nav.navigationBar.prefersLargeTitles = true
        }

        setViewControllers([nav1, nav2], animated: true)
    }
}
