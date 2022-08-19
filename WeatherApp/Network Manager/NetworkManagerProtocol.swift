//
//  NetworkManagerProtocol.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchCurrentWeather(city: String, completion: @escaping (Weather) -> ())
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (Weather) -> ())
    func fetchNextFiveWeatherForecast(city: String, completion: @escaping ([ForecastTemperature]) -> ())
}
