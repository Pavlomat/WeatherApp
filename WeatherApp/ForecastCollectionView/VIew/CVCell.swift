//
//  CVCell.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 26.08.2022.
//

import UIKit

class CVCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
    }

//    func configure(with item: DayForecast) {
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
//
//        if let date = dateFormatterGet.date(from: item.time) {
//            timeLabel.text = dateFormatter.string(from: date)
//        }
//        
//        imageView.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(item.icon)@2x.png")
//        temperatureLabel.text = String(item.temp.kelvinToCeliusConverter()) + " °C"
//    }
}
