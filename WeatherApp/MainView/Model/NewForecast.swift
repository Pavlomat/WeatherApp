////
////  NewForecast.swift
////  WeatherApp
////
////  Created by Pavlov Matvey on 27.08.2022.
////
//
//import Foundation
//
//// MARK: - Forecast
//struct Forecast: Codable {
//    let cod: String?
//    let message, cnt: Int?
//    let list: [List]?
//    let city: City?
//}
//
//// MARK: - City
//struct City: Codable {
//    let id: Int?
//    let name: String?
//    let coord: CoordForecast?
//    let country: String?
//    let population, timezone, sunrise, sunset: Int?
//}
//
//// MARK: - Coord
//struct CoordForecast: Codable {
//    let lat, lon: Double?
//}
//
//// MARK: - List
//struct List: Codable {
//    let dt: Int?
//    let main: MainClass?
//    let weather: [WeatherForecast]?
//    let clouds: CloudsForecast?
//    let wind: WindForecast?
//    let visibility: Int?
//    let pop: Double?
//    let sys: SysForecast?
//    let dtTxt: String?
//    let rain: Rain?
//
//    enum CodingKeys: String, CodingKey {
//        case dt, main, weather, clouds, wind, visibility, pop, sys
//        case dtTxt = "dt_txt"
//        case rain
//    }
//}
//
//// MARK: - Clouds
//struct CloudsForecast: Codable {
//    let all: Int?
//}
//
//// MARK: - MainClass
//struct MainClass: Codable {
//    let temp, feelsLike, tempMin, tempMax: Double?
//    let pressure, seaLevel, grndLevel, humidity: Int?
//    let tempKf: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case temp
//        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case pressure
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
//        case humidity
//        case tempKf = "temp_kf"
//    }
//}
//
//// MARK: - Rain
//struct Rain: Codable {
//    let the3H: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case the3H = "3h"
//    }
//}
//
//// MARK: - Sys
//struct SysForecast: Codable {
//    let pod: Pod?
//}
//
//enum Pod: String, Codable {
//    case d = "d"
//    case n = "n"
//}
//
//// MARK: - Weather
//struct WeatherForecast: Codable {
//    let id: Int?
//    let main: MainEnum?
//    let weatherDescription: Description?
//    let icon: Icon?
//
//    enum CodingKeys: String, CodingKey {
//        case id, main
//        case weatherDescription = "description"
//        case icon
//    }
//}
//
//enum Icon: String, Codable {
//    case the02D = "02d"
//    case the03D = "03d"
//    case the04D = "04d"
//    case the04N = "04n"
//    case the10D = "10d"
//    case the10N = "10n"
//}
//
//enum MainEnum: String, Codable {
//    case clouds = "Clouds"
//    case rain = "Rain"
//}
//
//enum Description: String, Codable {
//    case brokenClouds = "broken clouds"
//    case fewClouds = "few clouds"
//    case lightRain = "light rain"
//    case overcastClouds = "overcast clouds"
//    case scatteredClouds = "scattered clouds"
//}
//
//// MARK: - Wind
//struct WindForecast: Codable {
//    let speed: Double?
//    let deg: Int?
//    let gust: Double?
//}
