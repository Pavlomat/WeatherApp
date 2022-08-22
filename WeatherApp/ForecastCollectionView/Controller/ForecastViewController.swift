//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import UIKit

class ForecastViewController: UICollectionViewController {
    
    let networkManager = WeatherNetworkManager()
    var forecastData = [ForecastTemperature]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        networkManager.fetchNextFiveWeatherForecast(city: city) { (forecast) in
            self.forecastData = forecast
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ForecastCell
        let data = forecastData[indexPath.item]
        cell.dayLabel.text = data.weekDay
        cell.minTemperature.text = (data.hourlyForecast?[0].min_temp.kelvinToCeliusConverter() ?? "") + "º"
        cell.maxTemperature.text = (data.hourlyForecast?[2].max_temp.kelvinToCeliusConverter() ?? "") + "º"
        if let iconURL = data.hourlyForecast?[2].icon {
            cell.imageView.loadImageFromURL(url: "https://openweathermap.org/img/wn/\(iconURL)@2x.png")
        }
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        forecastData = []
    }
}
