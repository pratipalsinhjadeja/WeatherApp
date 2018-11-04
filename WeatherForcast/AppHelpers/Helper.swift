//
//  Helper.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 04/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages
class Helper{
    static func getTime(timeInterval: Int64, isMinute: Bool) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        if isMinute == true {
            dateFormatter.dateFormat = "hh:MM a"
        }else{
            dateFormatter.dateFormat = "h a"
        }
        return dateFormatter.string(from: date)
    }
    
    static func getHour(timeInterval: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        let hour = dateFormatter.calendar.component(.hour, from: date as Date)
        return "\(hour)"
    }
    
    static func windDirection(degrees: Double) -> String {
        var directions =  ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let i = Int((degrees + 11.25) / 22.5)
        return directions[i % 16]
    }
    
    static func getDayName(timeInterval: Int64) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat  = "EEEE"
        return dateFormatter.string(from: date as Date)
    }
    
    static func getImageUrl(logo: String) -> String{
        let url = "\(WebAPI.WeatherImageUrl)\(logo).png"
        return url
    }
    
    static func getTemp(temperature: Double) -> String {
        return"\(temperature)\u{00B0}"
    }
    
    static func getPresure(presure: Int) -> String {
        return "\(presure) hPa"
    }
    
    static func getPercentage(value: Int) -> String {
        return "\(value)%"
    }
    
    static func getWind(degrees: Double, speed: Double) -> String {
        return "\(Helper.windDirection(degrees: degrees)) \(speed) km/hr"
    }
}

extension UIViewController{
    func showBanner(title: String?, message: String, theme: Theme, position: SwiftMessages.PresentationStyle) {
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = position
        config.presentationContext = .automatic
        config.duration = .seconds(seconds: 4)
        // Dim the background like a popover view. Hide when the background is tapped.
        config.dimMode = .color(color: UIColor.init(white: 1.0, alpha: 0.0), interactive: true)
        config.preferredStatusBarStyle = .lightContent
        let view = MessageView.viewFromNib(layout: .tabView)
        view.configureTheme(theme)
        view.configureDropShadow()
        view.button?.isHidden = true
        view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
        view.tapHandler = { _ in
            SwiftMessages.hide()
            
        }
        SwiftMessages.show(config: config, view: view)
    }
}
