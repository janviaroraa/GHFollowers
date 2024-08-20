//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView?

extension UIViewController {

    // For closures that have a very short lifetime, like those in UIView.animate or DispatchQueue.async, the risk of creating a strong reference cycle is minimal. The system itself ensures that the closure doesn't outlive the context where it's executed.
    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let vc = GFAlertViewController(
                alertTitle: title,
                alertDesc: message,
                alertButton: buttonTitle
            )
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
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
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }

    func presentSafariViewController(url: URL) {
        let vc = SFSafariViewController(url: url)
        vc.preferredControlTintColor = .systemGreen
        present(vc, animated: true)
    }
}
