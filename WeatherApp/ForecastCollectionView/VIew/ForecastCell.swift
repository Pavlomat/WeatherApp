//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
    }
}
