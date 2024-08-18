//
//  FollowersListViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

class FollowersListViewController: UIViewController {

    // Enums are Hashable by default
    enum Section {
        case main
    }
    
    var username: String? = nil
    private var page = 1
    private var hasMoreFollowers = true
    private var isSearching = false

    private var followers = [Follower]()
    private var filteredFollowers = [Follower]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?

    private lazy var followersCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.configureFlowLayout(in: view))
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FollowersCollectionViewCell.self, forCellWithReuseIdentifier: FollowersCollectionViewCell.identifier)
        cv.delegate = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchBar()
        getFollowers(username: username ?? "", page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func addView() {
        view.addSubview(followersCollectionView)
    }

    private func layoutConstraints() {
        NSLayoutConstraint.activate([
            followersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            followersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            followersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            followersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func configureSearchBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        // Default value = false
        // If it's turned to false, then our background won't get faded and will remain same.
        // Else it makes the background a little greyish when we tap on search bar if turned true.
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.placeholder = "Find a follower..."
        navigationItem.searchController = searchController
        view.layoutSubviews()
        addView()
        layoutConstraints()
    }

    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        
        NetworkManager.shared.getFollowers(for: username, pageNumber: page) { [weak self] result in
            self?.hideLoadingView()
            switch result {
            case .success(let followers):
                if followers.count < 99 {
                    self?.hasMoreFollowers = false
                }
                self?.followers.append(contentsOf: followers)

                if let followers = self?.followers, followers.isEmpty {
                    DispatchQueue.main.async {
                        self?.showEmptyState(with: "This user doesn't have any followers. Please check the username", in: self?.view)
                    }
                    return
                }

                self?.updateData(with: followers)
            case .failure(let error):
                self?.presentAlert(
                    title: "Something went wrong!",
                    message: error.rawValue,
                    buttonTitle: "OK"
                )
            }
        }
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: followersCollectionView, cellProvider: { collectionView, indexPath, follower in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowersCollectionViewCell.identifier, for: indexPath) as? FollowersCollectionViewCell else { fatalError() }
            cell.configure(follower: follower)
            return cell
        })
    }

    private func updateData(with followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)

        DispatchQueue.main.async {
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }
}

// UICollectionViewDelegate confoms to UIScrollViewDelegate, so we are using UIScrollViewDelegate's methods in below extension.
extension FollowersListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let selectedFollower = isSearching ? filteredFollowers[indexPath.row] : followers[indexPath.row]

        // To get the default navigation items on UserInfoViewController's nav bar because we are presenting it modally
        let vc = UserInfoViewController(follower: selectedFollower)
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let username, hasMoreFollowers else { return }

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - scrollViewHeight {
            page += 1
            getFollowers(username: username, page: page)
        }
    }
}

extension FollowersListViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text,
              !searchText.isEmpty else {
            updateData(with: followers)
            return
        }
        isSearching = true
        filteredFollowers = followers.filter {
            $0.login?.lowercased().contains(searchText.lowercased()) ?? false
        }
        updateData(with: filteredFollowers)
    }
}

extension FollowersListViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(with: followers)
        followersCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
