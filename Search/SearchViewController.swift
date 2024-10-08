//
//  SearchViewController.swift
//  GHFollowers
//
//  Created by Janvi Arora on 09/08/24.
//

import UIKit

class SearchViewController: UIViewController {

    var isUsernameEmpty: Bool {
        return usernameTextField.text?.isEmpty ?? true
    }

    private lazy var logoImageView: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: SFSymbols.logo))
        imgV.translatesAutoresizingMaskIntoConstraints = false
        imgV.contentMode = .scaleAspectFit
        return imgV
    }()

    private var usernameTextField = GFTextField()
    private var callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addViews()
        layoutConstraints()
        dismissKeyboard()

        usernameTextField.delegate = self
        callToActionButton.addTarget(self, action: #selector(navigateToFollowersVC), for: .touchUpInside)
    }

    // We want to make isNavigationBarHidden false in viewWillAppear instead of viewDidLoad because we want navigation bar to be hidden each time our view appears. viewDidLoad only gets called the first time our view gets loaded
    // If we make isNavigationBarHidden false in viewDidLoad, then it would have worked fine for the first time,a nd let's say we navigate to another screen, but when we pop that screen, & navigate to SearchViewController again, navigation bar won't be hidden because navigation bar would have been there on the next screen or vc.
    // Earlier, isNavigationBarHidden was used but then it was found that during transition from SearchVC to FollowersListVC and navigating back half way disappears the nav bar (attached an image in assets for reference). So, make the navigation transition smoother we use setNavigationBarHidden func.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func addViews() {
        view.addSubviews(logoImageView, usernameTextField, callToActionButton)
    }

    private func layoutConstraints() {
        var logoImageViewTopConstraint: CGFloat = (DeviceTypes.isIphoneSE || DeviceTypes.isIphone8Zoomed) ? 20 : 80

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: logoImageViewTopConstraint),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),

            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),

            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func dismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func dismissKeyboardAction() {
        view.endEditing(true)
    }

    @objc
    private func navigateToFollowersVC() {
        guard !isUsernameEmpty, let username = usernameTextField.text else {
            presentAlert(
                title: "Empty Username!",
                message: "Please enter a username. We need to know whose followers to look for.",
                buttonTitle: "OK"
            )
            return
        }

        // To resolve the bug while navigating to next screen & navigating back. Can be reproduced on real device.
        // (SS can be found in Resources > Assets > NavigationBug)

        // Soln. 1
        usernameTextField.resignFirstResponder()

        // Soln. 2
        // view.endEditing(true)

        let vc = FollowersListViewController(username: username)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        navigateToFollowersVC()
        return true
    }
}
