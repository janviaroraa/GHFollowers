//
//  FavouritesListViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 11/08/24.
//

import UIKit

class FavouritesListViewController: UIViewController {

    private var favourites = [Follower]()

    private lazy var favouritesTableview: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(FavouritesTableViewCell.self, forCellReuseIdentifier: FavouritesTableViewCell.identifier)
        tv.rowHeight = 80
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addViews()
        layoutConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }

    private func addViews() {
        view.addSubviews(favouritesTableview)
    }

    private func layoutConstraints() {
        favouritesTableview.frame = view.bounds
    }

    private func getFavourites() {
        PersistenceManager.retrieveFavourites { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let favourites):
                if favourites.isEmpty {
                    self.showEmptyState(with: "No Favourites? \n Add one on the follower screen.", in: self.view)
                    return
                }
                self.favourites = favourites
                DispatchQueue.main.async {
                    self.favouritesTableview.reloadData()

                    // We want to bring favouritesTableview to the front, just in case empty state gets populated on the top of it. This is kinda an edge-case but this way we can always make sure that our favouritesTableview is going to be upfront & showing.
                    self.view.bringSubviewToFront(self.favouritesTableview)
                }
            case .failure(let error):
                self.presentAlert(
                    title: "Something went wrong!",
                    message: error.rawValue,
                    buttonTitle: "OK"
                )
            }
        }
    }
}

extension FavouritesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesTableViewCell.identifier, for: indexPath) as? FavouritesTableViewCell else { fatalError() }
        cell.configure(favourite: favourites[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let selectedFavourite = favourites[indexPath.row]
        favourites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)

        PersistenceManager.update(selectedFavourite, actionType: .remove) { [weak self] error in
            if let error {
                self?.presentAlert(
                    title: "Something went wrong!",
                    message: error.rawValue,
                    buttonTitle: "OK"
                )
                return
            }
        }
    }
}

extension FavouritesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedFavourite = favourites[indexPath.row]
        let vc = FollowersListViewController()
        vc.username = selectedFavourite.login
        vc.title = selectedFavourite.login
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(vc, animated: true)
    }
}
