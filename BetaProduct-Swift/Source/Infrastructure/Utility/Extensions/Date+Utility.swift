//
//  Date+Utility.swift
//  BetaProduct-Swift
//
//  Created by User on 2/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

extension Date {
    func convertStringDateToMMMDDYYYY(dateStringToFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let newFormat = DateFormatter()
        newFormat.dateFormat = "MMM dd, yyyy"
        if let date = dateFormatter.date(from: dateStringToFormat) {
            return newFormat.string(from: date)
        } else {
            return ""
        }
    }
}
