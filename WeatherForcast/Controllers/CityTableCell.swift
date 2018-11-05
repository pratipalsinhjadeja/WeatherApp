//
//  CityTableCell.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 05/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import UIKit

class CityTableCell: UITableViewCell {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblCity.font = UIFont.boldSystemFont(ofSize: 20)
        self.lblDate.font = UIFont.systemFont(ofSize: 15)
        self.lblTemp.font = UIFont.boldSystemFont(ofSize: 32)
        
        self.imgWeather.contentMode = .scaleAspectFill
        
        self.lblCity.textColor = .black
        self.lblDate.textColor = .lightGray
        self.lblTemp.textColor = .black
        
        self.lblCity.numberOfLines = 0
        self.lblCity.lineBreakMode = .byWordWrapping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
