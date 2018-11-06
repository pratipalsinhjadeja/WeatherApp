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
            dateFormatter.dateFormat = "dd-MM-yy hh:MM a"
        }else{
            dateFormatter.dateFormat = "hh a"
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
    
    static func barButtonItem(selector: Selector, controller: UIViewController, image: UIImage) -> UIBarButtonItem {
        let barButton = UIButton(type: .custom)
        barButton.setImage(image, for: .normal)
        barButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        barButton.addTarget(controller, action: selector, for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: barButton)
        return barItem
    }
}

extension UIViewController{
    
    func mainStoryboard() -> UIStoryboard {
        let main = UIStoryboard(name: "Main", bundle: nil)
        return main
    }
    
    func getNavCityListVC() -> UINavigationController {
        let nav = self.mainStoryboard().instantiateViewController(withIdentifier: "navCityListVC")
        return nav as! UINavigationController
    }
    
    func getNavLocationPickerVC() -> UINavigationController {
        let nav = self.mainStoryboard().instantiateViewController(withIdentifier: "navLocationPickerVC")
        return nav as! UINavigationController
    }
    
    func getNavAboutAppVC() -> UINavigationController {
        let nav = self.mainStoryboard().instantiateViewController(withIdentifier: "navAboutApp")
        return nav as! UINavigationController
    }
    func getNavSettingsVC() -> UINavigationController {
        let nav = self.mainStoryboard().instantiateViewController(withIdentifier: "navSettingsVC")
        return nav as! UINavigationController
    }
    
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

extension UITableView {
    
    func setEmptyMessage(_ message: String, buttonTitle: String, selector: Selector, labelColor: UIColor, target: UIViewController) {
        
        let vwEmpty = UIView(frame: CGRect(x: 0, y: 0, width: target.view.frame.size.width, height: self.bounds.size.height))
        vwEmpty.backgroundColor = UIColor.clear
        
        let messageLabel = UILabel(frame: CGRect(x: 16, y: vwEmpty.center.y, width: target.view.frame.size.width - 32, height:50))
        messageLabel.text = message
        
        messageLabel.center.x = vwEmpty.center.x
        messageLabel.textColor = labelColor
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        
        messageLabel.font = UIFont.systemFont(ofSize: 19.0)
        
        vwEmpty.addSubview(messageLabel)
        
        let button:UIButton = UIButton(frame: CGRect(x: 32, y: messageLabel.frame.origin.y + messageLabel.frame.size.height + 20
            , width: 200, height: 50))
        button.center.x = vwEmpty.center.x
        button.backgroundColor = UIColor.black
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(target, action: selector, for: .touchUpInside)
        
        vwEmpty.addSubview(button)
        
        self.backgroundView = vwEmpty;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

public extension Foundation.UserDefaults {
    public subscript(key: String) -> Any? {
        get { return value(forKey: key) as Any }
        set {
            switch newValue {
            case let value as Int: set(value, forKey: key)
            case let value as Double: set(value, forKey: key)
            case let value as Bool: set(value, forKey: key)
            case let value as URL: set(value, forKey: key)
            case let value as NSObject: set(value, forKey: key)
            case nil: removeObject(forKey: key)
            default: assertionFailure("Invalid value type.")
            }
        }
    }
    
    fileprivate func setter(key: String, value: Any?) {
        self[key] = value
        synchronize()
    }
    
    /// Is there a object for specific key exist.
    public func hasKey(_ key: String) -> Bool {
        return nil != object(forKey: key)
    }
    
}
