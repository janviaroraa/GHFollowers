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

    // Updated - iOS 15.0

    // O/P: Jan 2010
    func convertToMonthYearFormatUpdated() -> String {
        return formatted(.dateTime.month().year())
    }

    // O/P: January 10
    // Confusing because how will user know that `10` is year here!!!
    func case1() -> String {
        return formatted(.dateTime.month(.wide).year(.twoDigits))
    }

    // O/P: 01/2010
    func case2() -> String {
        return formatted(.dateTime.month(.twoDigits).year())
    }

    // O/P: 20/01/2010, 12:04 PM
    // Will give exact date and time
    func case3() -> String {
        return formatted()
    }
}
