//
//  MockUpdateCitySettingDelegate.swift
//  WeatherForcastTests
//
//  Created by Pratipal on 06/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation
import UIKit
@testable import WeatherForcast

class MockUpdateCitySettingDelegate: UpdateCitySettingDelegate{
    var viewController: UIViewController!
    
    func  refreshWeatherData(_ viewController: SettingsVC, isRemoveData: Bool) {
        self.viewController = viewController
    }
    
    
}
