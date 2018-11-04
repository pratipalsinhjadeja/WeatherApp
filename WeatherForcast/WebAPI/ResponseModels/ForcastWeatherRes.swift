//
//  ForcastWeatherRes.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 04/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation
struct ForcastWeatherRes: Codable {
    var cod:    Int
    var list:[WeatherForcast]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cod = try Int(container.decode(String.self, forKey: .cod)) ?? 0
        self.list = try container.decode([WeatherForcast].self, forKey: .list)
    }
}

struct WeatherForcast: Codable {
    var dt:     Int64
    var main:   Main
    var weather:[Weather]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decodeWrapper(key: .dt, defaultValue: 0)
        self.main = try container.decode(Main.self, forKey: .main)
        self.weather = try container.decode([Weather].self, forKey: .weather)
    }
}
