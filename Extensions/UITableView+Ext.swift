//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Janvi Arora on 22/08/24.
//

import UIKit

extension UITableView {

    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }

    func removeExtraCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
