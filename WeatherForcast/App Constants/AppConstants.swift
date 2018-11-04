//
//  AppConstants.swift
//  WeatherForcast
//
//  Created by Pratipal on 03/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation

struct APIKeys{
     static let WeatherKey = "c6e381d8c7ff98f0fee43775817cf6ad"
}

struct WebAPI {
    static let BaseURL = "https://api.openweathermap.org/data"
    static let TodayForcast = WebAPI.BaseURL+"/2.5/weather"
    static let FiveDaysForcast = WebAPI.BaseURL+"/2.5/forecast"
    static let MultipleCityGroup = WebAPI.BaseURL+"/2.5/group"
    static let WeatherImageUrl = "http://openweathermap.org/img/w/"
}

public enum WeatherUnits: String{
    case Standard = "Standard"
    case Metric = "metric"
    case Imparical = "imperial"
}
