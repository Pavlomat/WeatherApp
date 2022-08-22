//
//  Forecast.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import Foundation

struct DayForecast {
    let temp: Double
    let min_temp: Double
    let max_temp: Double
    let description: Description
    let icon: String
    let time: String
}

struct ForecastTemperature {
    let weekDay: String?
    let hourlyForecast: [DayForecast]?
}

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
    let coord: Coordinates?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Coord
struct Coordinates: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [WeatherForecast]?
    let clouds: CloudsForecast?
    let wind: WindForecast?
    let visibility, pop: Int?
    let sys: SysForecast?
    let dtTxt: String?
}

// MARK: - Clouds
struct CloudsForecast: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?
}

// MARK: - Sys
struct SysForecast: Codable {
    let pod: Pod?
}

enum Pod: Codable {
    case d
    case n
}

enum Icon: Codable {
    case the02D
    case the02N
    case the03D
    case the03N
    case the04D
    case the04N
}

// MARK: - Weather
struct WeatherForecast: Codable {
    let id: Int?
    let main: MainEnum?
    let weatherDescription: Description?
    let icon: String?
}

enum MainEnum: Codable {
    case clear
    case clouds
}

enum Description: Codable {
    case brokenClouds
    case clearSky
    case fewClouds
    case overcastClouds
    case scatteredClouds
}

// MARK: - Wind
struct WindForecast: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
