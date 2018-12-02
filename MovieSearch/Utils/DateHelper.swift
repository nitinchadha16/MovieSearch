//
//  DateHelper.swift
//  MovieSearch
//
//  Created by Nitin Chadha on 03/12/18.
//  Copyright © 2018 Nitin Chadha. All rights reserved.
//

import UIKit

struct DateHelper {
    static func calculatePastYears(year:String) -> String {
        let date = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        if let currentYear = components.year,let movieReleasedYear = Int(year) {
            return String(currentYear - movieReleasedYear)
        }
        return "-"
    }
}
