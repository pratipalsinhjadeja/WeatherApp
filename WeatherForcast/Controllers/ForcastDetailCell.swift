//
//  ForcastDetailCell.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 04/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import UIKit

class ForcastDetailCell: UICollectionViewCell {
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblTemp: UILabel!
    @IBOutlet var imgLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgLogo.contentMode = .scaleAspectFill
        self.lblTemp.textColor = UIColor.white
        self.lblTime.textColor = UIColor.white
        self.backgroundColor = UIColor.clear
    }
}
