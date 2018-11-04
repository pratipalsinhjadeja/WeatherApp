//
//  CurrentWeatherRes.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 04/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation
struct CurrentWeatherRes: Codable {
    var id:     Int
    var name:   String
    var cod:    Int
    var base:   String
    var dt:     Int64
    var coord:  Coord
    var main:   Main
    var sys:    Sys
    var wind:   Wind
    var rain: WeatherRain?
    var weather:[Weather]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeWrapper(key: .id, defaultValue: 0)
        self.name = try container.decodeWrapper(key: .name, defaultValue: "")
        self.cod = try container.decodeWrapper(key: .cod, defaultValue: 0)
        self.base = try container.decodeWrapper(key: .base, defaultValue: "")
        self.dt = try container.decodeWrapper(key:.dt, defaultValue:0)
        self.coord = try container.decode(Coord.self, forKey: .coord)
        self.main = try container.decode(Main.self, forKey: .main)
        self.sys = try container.decode(Sys.self, forKey: .sys)
        self.wind = try container.decode(Wind.self, forKey: .wind)
        self.rain = try container.decodeIfPresent(WeatherRain.self, forKey: .rain)
        self.weather = try container.decode([Weather].self, forKey: .weather)
    }
}

struct Coord: Codable {
    var lon: Double
    var lat: Double
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lat = try container.decodeWrapper(key: .lat, defaultValue: 0)
        self.lon = try container.decodeWrapper(key: .lon, defaultValue: 0)
    }
}

struct WeatherRain: Codable {
    var threeH: Int
    enum CodingKeys: String, CodingKey{
        case threeH = "3h"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.threeH = try container.decodeWrapper(key: .threeH, defaultValue: 0)
    }
}


struct Main: Codable {
    var temp: Double
    var pressure: Double
    var grnd_level: Double
    var humidity: Double
    var sea_level: Double
    var temp_max: Double
    var temp_min: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decodeWrapper(key: .temp, defaultValue: 0)
        self.pressure = try container.decodeWrapper(key: .pressure, defaultValue: 0)
        self.grnd_level = try container.decodeWrapper(key: .grnd_level, defaultValue: 0)
        self.humidity = try container.decodeWrapper(key: .temp, defaultValue: 0)
        self.sea_level = try container.decodeWrapper(key: .sea_level, defaultValue: 0)
        self.temp_max = try container.decodeWrapper(key: .temp_max, defaultValue: 0)
        self.temp_min = try container.decodeWrapper(key: .temp_min, defaultValue: 0)
    }

}

struct Wind: Codable {
    var deg: Double
    var speed: Double
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deg = try container.decodeWrapper(key: .deg, defaultValue: 0)
        self.speed = try container.decodeWrapper(key: .speed, defaultValue: 0)
    }
}

struct Sys: Codable {
    var country: String
    var message: Double
    var sunrise: Int32
    var sunset: Int32
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.country = try container.decodeWrapper(key: .country, defaultValue: "")
        self.message = try container.decodeWrapper(key: .message, defaultValue: 0)
        self.sunrise = try container.decodeWrapper(key: .sunrise, defaultValue: 0)
        self.sunset = try container.decodeWrapper(key: .sunset, defaultValue: 0)
    }
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeWrapper(key: .id, defaultValue: 0)
        self.main = try container.decodeWrapper(key: .main, defaultValue: "")
        self.icon = try container.decodeWrapper(key: .icon, defaultValue: "")
        self.description = try container.decodeWrapper(key: .description, defaultValue: "")
    }
}

