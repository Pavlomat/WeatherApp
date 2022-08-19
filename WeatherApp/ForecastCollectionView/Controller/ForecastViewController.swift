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
//        networkManager.fetchNextFiveWeatherForecast(city: city) { (forecast) in
//            self.forecastData = forecast
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return forecastData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ForecastCell
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        forecastData = []
    }
}
