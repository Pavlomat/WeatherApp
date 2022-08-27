//
//  WeatherNetworkManager.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import Foundation

class WeatherNetworkManager: NetworkManagerProtocol {
    
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (Weather) -> ()) {
        let apiURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(NetworkProperties.API_KEY)"
        apiRequest(urlString: apiURL, completion: completion)
    }
    
    func fetchCurrentWeather(city: String, completion: @escaping (Weather) -> ()) {
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let apiURL = "https://api.openweathermap.org/data/2.5/weather?q=\(formattedCity)&appid=\(NetworkProperties.API_KEY)"
        apiRequest(urlString: apiURL, completion: completion)
    }
    
    func apiRequest(urlString: String, completion: @escaping (Weather) -> ()) {
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard let data = data else { return }
            do {
                let currentWeather = try JSONDecoder().decode(Weather.self, from: data)
                completion(currentWeather)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func fetchNextFiveWeatherForecast(city: String, completion: @escaping ([ForecastTemperature]) -> ()) {
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        let apiURL = "https://api.openweathermap.org/data/2.5/forecast?q=\(formattedCity)&appid=\(NetworkProperties.API_KEY)"
        createModel(urlString: apiURL, completion: completion)
    }
    
    func fetchNextFiveWeatherForecastCoordinates(lat: String, lon: String, completion: @escaping ([ForecastTemperature]) -> ()) {
        let apiURL = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(NetworkProperties.API_KEY)"
        createModel(urlString: apiURL, completion: completion)
    }
    
    func createModel(urlString: String, completion: @escaping ([ForecastTemperature]) -> ()) {
        var currentDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var secondDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var thirdDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var fourthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var fifthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        var sixthDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
        
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard self != nil else { return }
            guard let data = data else { return }
            do {
                
                let forecastWeather = try JSONDecoder().decode(Forecast.self, from: data)
                
                var forecastmodelArray : [ForecastTemperature] = []
                var fetchedData : [DayForecast] = []
                
                var currentDayForecast : [DayForecast] = []
                var secondDayForecast : [DayForecast] = []
                var thirddayDayForecast : [DayForecast] = []
                var fourthDayDayForecast : [DayForecast] = []
                var fifthDayForecast : [DayForecast] = []
                var sixthDayForecast : [DayForecast] = []
                
                guard let totalData = forecastWeather.list?.count else { return }
                var dataCount = totalData
                
                for day in 0...dataCount - 1 {
                    
                    let listIndex = day
                    guard let mainTemp = forecastWeather.list?[listIndex].main?.temp else { return }
                    guard let minTemp = forecastWeather.list?[listIndex].main?.tempMin else { return }
                    guard let maxTemp = forecastWeather.list?[listIndex].main?.tempMax else { return }
                    guard let descriptionTemp = forecastWeather.list?[listIndex].weather?[0].weatherDescription else { return }
                    guard let icon = forecastWeather.list?[listIndex].weather?[0].icon else { return }
                    guard let time = forecastWeather.list?[listIndex].dtTxt else { return }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.calendar = Calendar(identifier: .gregorian)
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = dateFormatter.date(from: forecastWeather.list?[listIndex].dtTxt ?? "")
                    
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.weekday], from: date!)
                    let weekdaycomponent = components.weekday! - 1  //Just the integer value from 0 to 6
                    
                    let f = DateFormatter()
                    let weekday = f.weekdaySymbols[weekdaycomponent] // 0 Sunday 6 - Saturday //This is where we are getting the string val (Mon/Tue/Wed...)
                    
                    let currentDayComponent = calendar.dateComponents([.weekday], from: Date())
                    let currentWeekDay = currentDayComponent.weekday! - 1
                    let currentweekdaysymbol = f.weekdaySymbols[currentWeekDay]
                    
                    if weekdaycomponent == currentWeekDay - 1 {
                        dataCount -= 1
                    }
                    
                    if weekdaycomponent == currentWeekDay {
                        let info = DayForecast(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        currentDayForecast.append(info)
                        currentDayTemp = ForecastTemperature(weekDay: currentweekdaysymbol, hourlyForecast: currentDayForecast)
                        fetchedData.append(info)
                    } else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 1) {
                        let info = DayForecast(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        secondDayForecast.append(info)
                        secondDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: secondDayForecast)
                        fetchedData.append(info)
                    }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 2) {
                        let info = DayForecast(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        thirddayDayForecast.append(info)
                        thirdDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: thirddayDayForecast)
                        fetchedData.append(info)
                    }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 3) {
                        let info = DayForecast(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        fourthDayDayForecast.append(info)
                        fourthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: fourthDayDayForecast)
                        fetchedData.append(info)
                    }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 4){
                        let info = DayForecast(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        fifthDayForecast.append(info)
                        fifthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: fifthDayForecast)
                        fetchedData.append(info)
                    }else if weekdaycomponent == currentWeekDay.incrementWeekDays(by: 5) {
                        let info = DayForecast(temp: mainTemp, min_temp: minTemp, max_temp: maxTemp, description: descriptionTemp, icon: icon, time: time)
                        sixthDayForecast.append(info)
                        sixthDayTemp = ForecastTemperature(weekDay: weekday, hourlyForecast: sixthDayForecast)
                        fetchedData.append(info)
                    }
                    
                    if fetchedData.count == totalData {
                        
                        if currentDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastmodelArray.append(currentDayTemp)
                        }
                        
                        if secondDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastmodelArray.append(secondDayTemp)
                        }
                        
                        if thirdDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastmodelArray.append(thirdDayTemp)
                        }
                        
                        if fourthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastmodelArray.append(fourthDayTemp)
                        }
                        
                        if fifthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastmodelArray.append(fifthDayTemp)
                        }
                        
                        if sixthDayTemp.hourlyForecast?.count ?? 0 > 0 {
                            forecastmodelArray.append(sixthDayTemp)
                        }
                        
                        if forecastmodelArray.count <= 6 {
                            completion(forecastmodelArray)
                        }
                    }
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

