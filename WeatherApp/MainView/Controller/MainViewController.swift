//
//  ViewController.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var perceivedLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var conditionsLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var addCityButton: UIButton!
    
    let networkManager = WeatherNetworkManager()
    
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var forecastData: [ForecastTemperature] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        let location = locations[0].coordinate
        latitude = location.latitude
        longitude = location.longitude
        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
            DispatchQueue.main.async {
                self.setLabels(weather: weather)
            }
        }
    }
    
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
            DispatchQueue.main.async {
                self.setLabels(weather: weather)
            }
        }
    }
    
    func setLabels(weather: Weather) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt ?? 0)))
        
        temperatureLabel.text = (weather.main?.temp?.kelvinToCeliusConverter())! + "º"
        locationLabel.text = "\(weather.name ?? "") , \(weather.sys?.country ?? "")"
        dateLabel.text = stringDate
        perceivedLabel.text = "\(weather.main?.feelsLike?.kelvinToCeliusConverter() ?? "")" + "º"
        windLabel.text = "\(weather.wind?.speed?.cutFractional() ?? "")" + " km/h"
        humidityLabel.text = "\(weather.main?.humidity ?? 0)" + " %"
        conditionsLabel.text = "\(weather.weather?[0].main ?? "")"
        if let iconUrl = weather.weather?[0].icon {
            mainImageView.loadImageFromURL(url: "https://openweathermap.org/img/wn/\(iconUrl)@2x.png") }
        UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
    }
    
    //    @objc func handleShowForecast() {
    //        self.navigationController?.pushViewController(ForecastViewController(), animated: true)
    //    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadData(city: city)
        networkManager.fetchNextFiveWeatherForecast(city: city) { [weak self] (forecast) in
//            self?.forecastData = forecast
            print("\(forecast)")
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
        }
    }
    
    @IBAction func addCityButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "City Name"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let cityname = firstTextField.text else { return }
            self.loadData(city: cityname)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension MainViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCell
        return cell
    }
    
    func setupView() {
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        containerView.layer.cornerRadius = 15
        refreshButton.layer.borderWidth = 2
        refreshButton.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        refreshButton.layer.cornerRadius = 15
        addCityButton.layer.borderWidth = 2
        addCityButton.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        addCityButton.layer.cornerRadius = 15
    }
}

