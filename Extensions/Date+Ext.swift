//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
