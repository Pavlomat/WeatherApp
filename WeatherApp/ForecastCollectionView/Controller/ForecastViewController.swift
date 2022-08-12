//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Pavlov Matvey on 12.08.2022.
//

import UIKit

class ForecastViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 6
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    
        return cell
    }

}
