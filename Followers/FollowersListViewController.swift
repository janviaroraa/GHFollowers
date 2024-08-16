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

    private var followers = [Follower]()
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
        getFollowers(username: username ?? "", page: page)
        addView()
        layoutConstraints()
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
                self?.updateData()
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

    private func updateData() {
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
