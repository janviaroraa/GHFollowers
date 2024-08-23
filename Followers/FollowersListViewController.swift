//
//  FollowersListViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

class FollowersListViewController: GFDataLoadingViewcontroller {

    // Enums are Hashable by default
    enum Section {
        case main
    }
    
    var username: String
    private var page = 1
    private var hasMoreFollowers = true
    private var isSearching = false
    private var isLoadingMoreFollowers = false

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

    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = username
        configureSearchBar()
        configureNavBar()
        getFollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configureNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
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
        isLoadingMoreFollowers = true

        NetworkManager.shared.getFollowers(for: username, pageNumber: page) { [weak self] result in
            self?.dismissLoadingView()
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
            self?.isLoadingMoreFollowers = false
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

    @objc
    private func addButtonTapped() {
        showLoadingView()

        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let follower):
                let favourite = Follower(login: follower.login, avatarUrl: follower.avatarUrl)
                PersistenceManager.update(favourite, actionType: .add) { [weak self] error in
                    if let error {
                        self?.presentAlert(
                            title: "Something went wrong!",
                            message: error.rawValue,
                            buttonTitle: "OK"
                        )
                        return
                    }
                    self?.presentAlert(
                        title: "Added to Favourites ⚝",
                        message: "GitHub user - \(follower.name ?? "") with account \(follower.login ?? "") is added to Favourites List. Go in Favourites Section to modify.",
                        buttonTitle: "OK"
                    )
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

// UICollectionViewDelegate confoms to UIScrollViewDelegate, so we are using UIScrollViewDelegate's methods in below extension.
extension FollowersListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let selectedFollower = isSearching ? filteredFollowers[indexPath.row] : followers[indexPath.row]

        // To get the default navigation items on UserInfoViewController's nav bar because we are presenting it modally
        let vc = UserInfoViewController(follower: selectedFollower)
        vc.delegate = self
        let navigationController = UINavigationController(rootViewController: vc)
        present(navigationController, animated: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard hasMoreFollowers, !isLoadingMoreFollowers else { return }

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
            isSearching = false
            filteredFollowers.removeAll()
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
        followersCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}

extension FollowersListViewController: UserInfoDelegate {

    func updateFollowers(for username: String?) {
        // Both approaches work same

        // Approach 1
        guard let username else { return }
        title = username
        self.username = username
        getFollowers(username: username, page: 1)
        followersCollectionView.reloadData()

        // Approach 2
        // guard let username else { return }
        // self.username = username
        // title = username
        // page = 1
        // followers.removeAll()
        // filteredFollowers.removeAll()

        // NOTE: to scroll upto the top real quick
        // followersCollectionView.setContentOffset(.zero, animated: true)

        // getFollowers(username: username, page: page)
    }
}
