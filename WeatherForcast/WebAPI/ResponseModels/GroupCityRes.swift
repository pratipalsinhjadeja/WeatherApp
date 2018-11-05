//
//  GroupCityRes.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 05/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation
struct GroupCityRes: Codable {
    var cnt:    Int
    var list:[WeatherForcast]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cnt = try Int(container.decode(String.self, forKey: .cnt)) ?? 0
        self.list = try container.decode([WeatherForcast].self, forKey: .list)
    }
}
