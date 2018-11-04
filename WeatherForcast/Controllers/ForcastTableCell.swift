//
//  ForcastTableCell.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 04/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import UIKit
import AlamofireImage

class ForcastTableCell: UITableViewCell {
    
    @IBOutlet var cvForcast: UICollectionView!
    var arrForcast:[WeatherForcast] = [] { didSet { self.cvForcast.reloadData()} }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.cvForcast.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension ForcastTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrForcast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForcastDetailCell", for: indexPath) as! ForcastDetailCell
        let forcast = self.arrForcast[indexPath.item]
        
        cell.lblTime.text = Helper.getTime(timeInterval: forcast.dt, isMinute: false)
        cell.lblTemp.text = Helper.getTemp(temperature: forcast.main.temp)

        if forcast.weather.count>0{
            let url = URL(string: Helper.getImageUrl(logo: forcast.weather.first!.icon))!
            cell.imgLogo.af_setImage(withURL: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 66, height: 99.0)
    }
    
}
