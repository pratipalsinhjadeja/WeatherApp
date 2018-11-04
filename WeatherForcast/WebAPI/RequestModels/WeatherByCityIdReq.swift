//
//  WeatherByCityIdReq.swift
//  WeatherForcast
//
//  Created by Pratipal on 03/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation
struct  WeatherByCityIdReq: CommonParameters {
    var APIKey: String
    var cityId: String?
    var unit: String?
    
    init(cityId: String?,unit:String?) {
        self.APIKey = APIKeys.WeatherKey
        self.cityId = cityId
        self.unit = unit
    }
    
    public func getParameters() -> [String: Any] {
        var params = [String: Any]()
        
        params["appid"] = self.APIKey
        
        if let id = self.cityId {
            params["id"] = id
        }
        
        if let units = self.unit, !units.isEmpty {
            params["units"] = units
        }
        
        return params
    }
}
