//
//  NetworkManagerProtocol.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 27.08.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (Weather) -> ())
    func fetchCurrentWeather(city: String, completion: @escaping (Weather) -> ())
    func fetchNextFiveWeatherForecast(city: String, completion: @escaping ([ForecastTemperature]) -> ())
    func fetchNextFiveWeatherForecastCoordinates(lat: String, lon: String, completion: @escaping ([ForecastTemperature]) -> ())
}
