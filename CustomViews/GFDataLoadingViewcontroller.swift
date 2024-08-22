//
//  GFDataLoadingViewcontroller.swift
//  GHFollowers
//
//  Created by Janvi Arora on 21/08/24.
//

import UIKit

class GFDataLoadingViewcontroller: UIViewController {

    private var containerView: UIView?

    func showLoadingView() {
        containerView = UIView(frame: view.bounds)

        guard let containerView else { return }
        view.addSubview(containerView)

        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0

        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])

        activityIndicator.startAnimating()
    }

    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView?.removeFromSuperview()
            self.containerView = nil
        }
    }

    func showEmptyState(with message: String, in view: UIView?) {
        DispatchQueue.main.async {
            guard let view, view.bounds.size != .zero else {
                print("Error: view's bounds are zero. Cannot display empty state.")
                return
            }

            let emptyView = GFEmptyStateView(message: message)
            emptyView.frame = view.bounds
            view.addSubview(emptyView)
        }
    }
}
