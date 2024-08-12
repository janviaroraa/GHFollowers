//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

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
}
