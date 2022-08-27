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
    @IBOutlet weak var showForecastButton: UIButton!
    
    let networkManager = WeatherNetworkManager()
    
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var forecastData: [ForecastTemperature] = []
    var currentDayTemp = ForecastTemperature(weekDay: nil, hourlyForecast: nil, cityName: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        checkUsersLocationServicesAuthorization()
    }
    
    func checkUsersLocationServicesAuthorization(){
        if CLLocationManager.locationServicesEnabled() {
                    switch locationManager.authorizationStatus {
               case .notDetermined:
                   self.locationManager.delegate = self
                        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                   locationManager.requestWhenInUseAuthorization()
                   break

               case .restricted, .denied:
                        currentCityButton.isHidden = true
                   let ac = UIAlertController(title: "Location denied", message: "App needs access to your location. Turn on Location Services in your device settings or provide city.", preferredStyle: UIAlertController.Style.alert)
                   ac.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                       guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                           return
                       }
                       if UIApplication.shared.canOpenURL(settingsUrl) {
                           UIApplication.shared.open(settingsUrl)
                       }
                   }))
                        ac.addAction(UIAlertAction(title: "Provide", style: UIAlertAction.Style.default) { [weak self] _ in
                            let ac = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
                            ac.addTextField { (textField : UITextField!) -> Void in
                                textField.placeholder = "City Name"
                            }
                            let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
                                let firstTextField = ac.textFields![0] as UITextField
                                guard let city = firstTextField.text else { return }
                                self?.loadDataUsingCity(city: city)
                                self?.loadForecastUsingCity(city: city)
                            })
                            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
                                print("Cancel")
                            })
                            ac.addAction(saveAction)
                            ac.addAction(cancelAction)
                            self?.present(ac, animated: true)
                        })
                   DispatchQueue.main.async{
                        self.present(ac, animated: true)
                   }
                   break

               case .authorizedWhenInUse, .authorizedAlways:
                        currentCityButton.isHidden = false
                        guard let location = locationManager.location?.coordinate else { return }
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
            UserDefaults.standard.set("\(self?.forecastData[0].cityName ?? "")", forKey: "SelectedCity")
//            print(self?.forecastData[0].cityName!)
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func loadForecastUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchNextFiveWeatherForecastCoordinates(lat: lat, lon: lon) { [weak self] (forecast) in
            self?.forecastData = forecast
            self?.currentDayTemp = (self?.forecastData[0])!
            UserDefaults.standard.set("\(self?.forecastData[0].cityName ?? "")", forKey: "SelectedCity")
//            print(self?.forecastData[0].cityName!)
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
        let ac = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
        ac.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "City Name"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            let firstTextField = ac.textFields![0] as UITextField
            guard let city = firstTextField.text else { return }
            self?.loadDataUsingCity(city: city)
            self?.loadForecastUsingCity(city: city)
            UserDefaults.standard.set("\(city)", forKey: "SelectedCity")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        ac.addAction(saveAction)
        ac.addAction(cancelAction)
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func showFOrecastButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "MainToForecastSegue", sender: nil)
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

