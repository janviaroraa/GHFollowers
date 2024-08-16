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
    var followers = [Follower]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>?

    private lazy var followersCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: configureFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FollowersCollectionViewCell.self, forCellWithReuseIdentifier: FollowersCollectionViewCell.identifier)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getFollowers()
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

    private func getFollowers() {
        guard let username else { return }
        NetworkManager.shared.getFollowers(for: username, pageNumber: 1) { [weak self] result in
            switch result {
            case .success(let followers):
                self?.followers = followers
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

    private func configureFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth/3

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)

        return flowLayout
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
