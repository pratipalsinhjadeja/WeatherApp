//
//  CityWeatherDetailVC.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 03/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import UIKit
import Alamofire

struct ExtendedDetail {
    let title: String
    let value: String
}

class CityWeatherDetailVC: UIViewController {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblWeatherCondition: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var tblWeatherDetails: UITableView!
    
    let apiGroup = DispatchGroup()
    
    var arrForcast = [WeatherForcast]()
    var objWeatherData: CurrentWeatherRes!
    var arrExtendedInfo = [ExtendedDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupViews()
        
        self.apiGroup.enter()
        self.getCurrentWeather()
        self.apiGroup.enter()
        self.getForcastWeather()
        
        self.apiGroup.notify(queue: .main) { [weak self] in
            self?.tblWeatherDetails.reloadData()
        }
    }
    
    func setupViews() {
        self.tblWeatherDetails.backgroundColor = UIColor.clear
        self.tblWeatherDetails.tableFooterView = UIView()
        
        self.lblDay.font = UIFont.boldSystemFont(ofSize: 18)
        self.lblMaxTemp.font = UIFont.systemFont(ofSize: 18)
        self.lblMinTemp.font = UIFont.systemFont(ofSize: 18)
        
        self.lblDay.textColor = UIColor.white
        self.lblMinTemp.textColor = UIColor.init(white: 1, alpha: 0.7)
        self.lblMaxTemp.textColor = UIColor.white
    }
    
    func createExtendedDetailModels() {
        
        var objValue = Helper.getTemp(temperature: self.objWeatherData.main.temp_max)
        var objExtDetail = ExtendedDetail(title: Texts.feelLike, value: objValue)
        self.arrExtendedInfo.append(objExtDetail)
        
        objValue = Helper.getTime(timeInterval: Int64(self.objWeatherData.sys.sunrise), isMinute: false)
        objExtDetail = ExtendedDetail(title: Texts.sunrise, value: objValue)
        self.arrExtendedInfo.append(objExtDetail)
        
        objValue = Helper.getTime(timeInterval: Int64(self.objWeatherData.sys.sunset), isMinute: false)
        objExtDetail = ExtendedDetail(title: Texts.sunset, value: objValue)
        self.arrExtendedInfo.append(objExtDetail)
        
        objValue = Helper.getPercentage(value: Int(self.objWeatherData.main.humidity))
        objExtDetail = ExtendedDetail(title: Texts.humidity, value: objValue)
        self.arrExtendedInfo.append(objExtDetail)
        
        objValue = Helper.getPresure(presure: Int(self.objWeatherData.main.pressure))
        objExtDetail = ExtendedDetail(title: Texts.pressure, value: objValue)
        self.arrExtendedInfo.append(objExtDetail)
        
        if let rain = self.objWeatherData?.rain?.threeH{
            objValue = Helper.getPercentage(value: Int(rain))
            objExtDetail = ExtendedDetail(title: Texts.rainChances, value: objValue)
            self.arrExtendedInfo.append(objExtDetail)
        }
        
        objValue = Helper.getWind(degrees: self.objWeatherData.wind.deg, speed: self.objWeatherData.wind.speed)
        objExtDetail = ExtendedDetail(title: Texts.wind, value: objValue)
        self.arrExtendedInfo.append(objExtDetail)
    }
    
    func setupHeaderView() {
        self.lblCity.text = self.objWeatherData.name
        self.lblTemp.text = Helper.getTemp(temperature: self.objWeatherData.main.temp)
        if let objWeather = self.objWeatherData.weather.first {
            self.lblWeatherCondition.text = objWeather.main
        }
        self.lblDay.text = Helper.getDayName(timeInterval: self.objWeatherData?.dt ?? 0)
        self.lblMaxTemp.text = Helper.getTemp(temperature: self.objWeatherData.main.temp_max)
        self.lblMinTemp.text = Helper.getTemp(temperature: self.objWeatherData.main.temp_min)
    }
}

//MARK: Web API Calls
extension CityWeatherDetailVC {
    func getCurrentWeather()
    {
        let weatherReq = CurrentWeatherReq(lat: 23.0225, lon: 72.5714, unit: "metric")
        print(weatherReq.getParameters())
        DataManager.singleton.getRequest(WebAPI.TodayForcast, params: weatherReq.getParameters())
        { (response: Result<CurrentWeatherRes>) in
            
            self.apiGroup.leave()
            switch response {
            case .success(let value):
                print(value)
                self.objWeatherData = value
                if self.objWeatherData.cod == 200{
                    self.setupHeaderView()
                    self.createExtendedDetailModels()
                }
                else{
                    self.showBanner(title: nil, message: NetworkErrors.noResponseFound, theme: .error, position: .center)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.showBanner(title: nil, message: NetworkErrors.noResponseFound, theme: .error, position: .center)
                break
            }
        }
    }
    
    func getForcastWeather()
    {
        let weatherReq = CurrentWeatherReq(lat: 23.0225, lon: 72.5714, unit: "metric")
        print(weatherReq.getParameters())
        DataManager.singleton.getRequest(WebAPI.FiveDaysForcast, params: weatherReq.getParameters())
        { (response: Result<ForcastWeatherRes>) in
            
            self.apiGroup.leave()
            switch response {
            case .success(let value):
                print(value)
                let weatherData: ForcastWeatherRes = value
                if weatherData.cod == 200{
                    self.arrForcast = weatherData.list
                    //print(weatherData.list.first?.weather.first?.main ?? "")
                }
                else{
                    self.showBanner(title: nil, message: NetworkErrors.noResponseFound, theme: .error, position: .center)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.showBanner(title: nil, message: NetworkErrors.noResponseFound, theme: .error, position: .center)
                break
            }
        }
    }
}
//MARK: WeatherDetailTableview Delegate & DataSource
extension CityWeatherDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.arrExtendedInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForcastTableCell", for: indexPath) as! ForcastTableCell
            cell.arrForcast = self.arrForcast
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherExtendedInfoCell", for: indexPath) as! WeatherExtendedInfoCell
            
            let objExtInfo = self.arrExtendedInfo[indexPath.row]
            cell.lblTitle.text = objExtInfo.title
            cell.lblValue.text = objExtInfo.value
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        
        return 34
    }
    
}

