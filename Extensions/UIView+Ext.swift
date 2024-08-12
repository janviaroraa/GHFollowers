//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Janvi Arora on 12/08/24.
//

import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
