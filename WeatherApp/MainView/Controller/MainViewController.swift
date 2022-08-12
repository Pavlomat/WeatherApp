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
    
    let networkManager = WeatherNetworkManager()
    
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var stackView : UIStackView!
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
    
    
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
             let formatter = DateFormatter()
             formatter.dateFormat = "dd MMM yyyy" //yyyy
             let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
             
             DispatchQueue.main.async {
                 self.temperatureLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°")
                 self.perceivedLabel.text = (String(weather.main.feels_like.kelvinToCeliusConverter()) + "º")
                 self.locationLabel.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                 self.dateLabel.text = stringDate
//                 self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
//                 self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                 self.mainImageView.loadImageFromURL(url: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                 UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
             }
         }
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
//             print("Current Temperature", weather.main.temp.kelvinToCeliusConverter())
             let formatter = DateFormatter()
             formatter.dateFormat = "dd MMM yyyy" //yyyy
             let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
             
             DispatchQueue.main.async {
                 self.temperatureLabel.text = (String(weather.main.temp.kelvinToCeliusConverter()) + "°C")
                 self.locationLabel.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
//                 self.tempDescription.text = weather.weather[0].description
                 self.dateLabel.text = stringDate
//                 self.minTemp.text = ("Min: " + String(weather.main.temp_min.kelvinToCeliusConverter()) + "°C" )
//                 self.maxTemp.text = ("Max: " + String(weather.main.temp_max.kelvinToCeliusConverter()) + "°C" )
                 self.mainImageView.loadImageFromURL(url: "https://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
             }
        }
    }
    
    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
         alertController.addTextField { (textField : UITextField!) -> Void in
             textField.placeholder = "City Name"
         }
         let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
             let firstTextField = alertController.textFields![0] as UITextField
//             print("City Name: \(firstTextField.text ?? "Empty")")
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

    @objc func handleShowForecast() {
        self.navigationController?.pushViewController(ForecastViewController(), animated: true)
    }
    
    @objc func handleRefresh() {
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        loadData(city: city)
    }
}

extension MainViewController {
    func setupView() {
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        containerView.layer.cornerRadius = 15
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCell
        return cell
    }
}

