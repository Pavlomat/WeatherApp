//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import UIKit

class ForecastCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dailyForecast: [DayForecast] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        
        print("Hello")
        print("\(dailyForecast.count)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let cellNib = UINib(nibName: "CVCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "CVCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyForecast.count
//        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! CVCell
//        cell.configure(with: dailyForecast[indexPath.item])
        let data = dailyForecast[indexPath.item]

        
        cell.temperatureLabel.text = data.temp.kelvinToCeliusConverter() + "º"
        cell.timeLabel.text = data.time.correctTime()
        cell.imageView.loadImageFromURL(url: "https://openweathermap.org/img/wn/\(data.icon)@2x.png")
        
        return cell
    }
    
    func configure(with item: ForecastTemperature) {
        dailyForecast = item.hourlyForecast ?? []
    }
}
