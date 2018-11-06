//
//  WeatherExtendedInfoCell.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 04/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import UIKit

class WeatherExtendedInfoCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        
        self.lblTitle.textColor = UIColor.init(white: 1, alpha: 0.7)
        self.lblValue.textColor = UIColor.white
        self.lblTitle.font = UIFont.systemFont(ofSize: 18)
        self.lblValue.font = UIFont.boldSystemFont(ofSize: 20)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
