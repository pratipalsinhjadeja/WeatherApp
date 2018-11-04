//
//  CommonParameters.swift
//  WeatherForcast
//
//  Created by Pratipal on 03/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation

protocol  CommonParameters {
    var APIKey: String {get set}
    var unit: String? {get set}
}
