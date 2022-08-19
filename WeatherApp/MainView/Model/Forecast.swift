//
//  Forecast.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import Foundation

// MARK: - Forecast
struct Forecast: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [ForecastWeather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility, pop: Int?
    let sys: Sys?
    let dtTxt: String?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?
}

enum Pod: Codable {
    case d
    case n
}

// MARK: - Weather
struct ForecastWeather: Codable {
    let id: Int?
    let main: MainEnum?
    let weatherDescription: Description?
    let icon: Icon?
}

enum Icon: Codable {
    case the02D
    case the02N
    case the03D
    case the03N
    case the04D
    case the04N
}

enum MainEnum: Codable {
    case clouds
}

enum Description: Codable {
    case brokenClouds
    case fewClouds
    case overcastClouds
    case scatteredClouds
}

struct DayForecast {
    let mainTemp, minTemp, maxTemp: Double?
    let descriptionTemp: Description?
    let icon: Icon?
    let time: String?
}
struct ForecastTemperature {
    let weekDay: String?
    let hourlyForecast: [DayForecast]?
}

