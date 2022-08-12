//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
