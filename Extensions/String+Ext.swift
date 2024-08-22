//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Janvi Arora on 18/08/24.
//

import Foundation

// Not required now, since we nade `createdAt` property of `User` of type `Date`
extension String {

    // https://www.nsdateformatter.com/
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        // Location: english_India = en_IN
        dateFormatter.locale = Locale(identifier: "en_IN")

        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }

    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
