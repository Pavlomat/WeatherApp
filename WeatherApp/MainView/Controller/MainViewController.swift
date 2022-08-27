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
    @IBOutlet weak var currentCityButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var addCityButton: UIButton!
    
    let networkManager = WeatherNetworkManager()
    
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var forecastData: [ForecastTemperature] = []
    var currentDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        
        checkUsersLocationServicesAuthorization()
        
//        loadForecastUsingCity(city: UserDefaults.standard.string(forKey: "SelectedCity") ?? "")
    }
    
    func checkUsersLocationServicesAuthorization(){
           /// Check if user has authorized Total Plus to use Location Services
        if CLLocationManager.locationServicesEnabled() {
                    switch locationManager.authorizationStatus {
               case .notDetermined:
                   // Request when-in-use authorization initially
                   // This is the first and the ONLY time you will be able to ask the user for permission
                   self.locationManager.delegate = self
                        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                   locationManager.requestWhenInUseAuthorization()
                   break

               case .restricted, .denied:
                   // Disable location features
//                   switchAutoTaxDetection.isOn = false
                      
                        print("Acess denied")
                   let alert = UIAlertController(title: "Allow Location Access", message: "MyApp needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)

                   // Button to Open Settings
                   alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                       guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                           return
                       }
                       if UIApplication.shared.canOpenURL(settingsUrl) {
                           UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                               print("Settings opened: \(success)")
                           })
                       }
                   }))
                   alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                   DispatchQueue.main.async{
                        self.present(alert, animated: true, completion: nil)
                   }

                   break

               case .authorizedWhenInUse, .authorizedAlways:
                   // Enable features that require location services here.
                   print("Full Access")
                        guard let location = locationManager.location?.coordinate else { return }
//                        let location = locations[0].coordinate
                        latitude = location.latitude
                        longitude = location.longitude
                        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
                        loadForecastUsingCoordinates(lat: latitude.description, lon: longitude.description)
                   break
               @unknown default:
                   fatalError()
               }
           }
       }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        if CLLocationManager.locationServicesEnabled() {
//            switch locationManager.authorizationStatus {
//                case .notDetermined, .restricted, .denied:
//                let ac = UIAlertController(title: "Location denied", message: "Provide default city", preferredStyle: .alert)
//                ac.addTextField { (textField : UITextField!) -> Void in
//                    textField.placeholder = "City Name"
//                }
//                let saveAction = UIAlertAction(title: "Provide", style: .default, handler: { alert -> Void in
//                    let firstTextField = ac.textFields![0] as UITextField
//                    guard let city = firstTextField.text else { return }
//                    self.loadDataUsingCity(city: city)
//                    self.loadForecastUsingCity(city: city)
//                })
//                ac.addAction(saveAction)
//                present(ac, animated: true, completion: nil)
//
//                case .authorizedAlways, .authorizedWhenInUse:
//                    print("Access")
//                @unknown default:
//                    break
//            }
//        } else {
//            print("Location services are not enabled")
//        }
//
//        manager.stopUpdatingLocation()
//        manager.delegate = nil
//        let location = locations[0].coordinate
//        latitude = location.latitude
//        longitude = location.longitude
//        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
//        loadForecastUsingCoordinates(lat: latitude.description, lon: longitude.description)
//    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
            DispatchQueue.main.async {
                self.setLabels(weather: weather)
            }
        }
    }
    
    func loadDataUsingCity(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
            DispatchQueue.main.async {
                self.setLabels(weather: weather)
            }
        }
    }
    
    func loadForecastUsingCity(city: String) {
        networkManager.fetchNextFiveWeatherForecast(city: city) { [weak self] (forecast) in
            self?.forecastData = forecast
            self?.currentDayTemp = (self?.forecastData[0])!
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func loadForecastUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchNextFiveWeatherForecastCoordinates(lat: lat, lon: lon) { [weak self] (forecast) in
            self?.forecastData = forecast
            self?.currentDayTemp = (self?.forecastData[0])!
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
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
    
    @IBAction func currentLocationButtonTapped(_ sender: Any) {
        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
        loadForecastUsingCoordinates(lat: latitude.description, lon: longitude.description)
    }
    @IBAction func refreshButtonTapped(_ sender: Any) {
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadDataUsingCity(city: city)
        loadForecastUsingCity(city: city)
    }
    
    @IBAction func addCityButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "City Name"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let city = firstTextField.text else { return }
            self.loadDataUsingCity(city: city)
            self.loadForecastUsingCity(city: city)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension MainViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return currentDayTemp.hourlyForecast?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCell
        let data = currentDayTemp.hourlyForecast![indexPath.item]
        cell.temperatureLabel.text = data.temp.kelvinToCeliusConverter() + "º"
        cell.timeLabel.text = data.time.correctTime()
        cell.imageVIew.loadImageFromURL(url: "https://openweathermap.org/img/wn/\(data.icon)@2x.png")
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
        currentCityButton.layer.borderWidth = 2
        currentCityButton.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        currentCityButton.layer.cornerRadius = 15
    }
}

