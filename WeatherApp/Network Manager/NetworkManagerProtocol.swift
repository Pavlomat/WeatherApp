//
//  NetworkManagerProtocol.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ())
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (WeatherModel) -> ())
    func fetchNextFiveWeatherForecast(city: String, completion: @escaping ([ForecastTemperature]) -> ())
}
