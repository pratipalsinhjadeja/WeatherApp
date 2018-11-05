//
//  Texts.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 04/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation

struct Texts {
    //City Weather Detail
    static let wind = "Wind:"
    static let rainChances = "Chances of Rain:"
    static let feelLike = "Feel Like:"
    static let sunrise = "Sunrise:"
    static let sunset = "Sunset:"
    static let humidity = "Humidity:"
    static let pressure = "Pressure:"
    
    //City Weather
    static let tableEmpty = "No Bookmarked city found. please tap on 'Select City'"
    static let selectCity = "Select City"
    static let updatedOn = "Updated on:"
    
    //City List
    static let bookmarkedCity = "Bookmarked City"
    
    //unwindSegue
    static let unwindSeguetoWeather = "unwindToCityWeatherDetail"
    
    //Settings Screen
    static let AppSettings = "Weather Settings"
    static let weatherUnit = "Weather Units"
    static let removeAllCities = "Remove all cities"
    static let removeAllInfo = "are you sure?"
    static let selectUnit = "Select Preffered Unit"
}
struct NetworkErrors {
    static let title = "Error"
    static let noResponseFound = "No response Found"
    static let networkUnavailable = "Network Unavailable"
}
