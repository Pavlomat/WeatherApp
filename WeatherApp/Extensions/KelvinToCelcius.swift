//
//  KelvinToCelcius.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import Foundation

extension Double {
    
    func kelvinToCeliusConverter() -> String {
        let const : Double = 273.15
        let kelValue = self
        let celValue = kelValue - const
        return String(format: "%.0f", celValue)
    }
}
