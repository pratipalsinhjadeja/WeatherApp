//
//  GroupCityRes.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 05/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation
struct GroupCityRes: Codable {
    var list:[WeatherForcast]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.list = try container.decode([WeatherForcast].self, forKey: .list)
    }
}
