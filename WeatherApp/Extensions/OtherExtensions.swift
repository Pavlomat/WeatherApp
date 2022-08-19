//
//  Extensions.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 19.08.2022.
//

import Foundation

extension Double {
    
    func kelvinToCeliusConverter() -> String {
        let const : Double = 273.15
        let kelValue = self
        let celValue = kelValue - const
        return String(format: "%.0f", celValue)
    }
    
    func cutFractional() -> String {
        let value = self
        return String(format: "%.0f", value)
    }
}

extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementedVal = self + num
        let mod = incrementedVal % 7
        
        return mod
    }
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
