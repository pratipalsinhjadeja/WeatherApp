//
//  CurrentWeatherReq.swift
//  WeatherForcast
//
//  Created by Pratipal on 03/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation
struct  CurrentWeatherReq: CommonParameters {
    var APIKey: String
    var lat: Double?
    var lon: Double?
    var unit: String?
    
    init(lat: Double,lon:Double,unit:String) {
        self.APIKey = APIKeys.WeatherKey
        self.lat = lat
        self.lon = lon
        self.unit = unit
    }
    
    public func getParameters() -> [String: Any] {
        var params = [String: Any]()
        
        params["appid"] = self.APIKey
        
        if let latitude = self.lat {
            params["lat"] = latitude
        }
        
        if let longitude = self.lon {
            params["lon"] = longitude
        }
        
        if let units = self.unit, !units.isEmpty {
            params["units"] = units
        }
        
        return params
    }
}
