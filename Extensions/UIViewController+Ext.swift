//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

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

    func hideLoadingView() {
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            containerView = nil
        }
    }
}
