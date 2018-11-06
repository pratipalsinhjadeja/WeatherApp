//
//  CityListVC.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 05/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import AlamofireImage

protocol UpdateCityWeatherDelegate {
    func updateCityWeatherController(coordinate: CLLocationCoordinate2D)
}

class CityListVC: UIViewController {
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var tblCities: UITableView!
    let databaseInstance = DataOperation.singleton
    var arrCities = [City]()
    var refreshControl = UIRefreshControl()
    var delegate: UpdateCityWeatherDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        // Do any additional setup after loading the view.
        self.fetchBookmarkedCities()
    }
    
    func setupViews(){
    
        refreshControl.addTarget(self, action: #selector(self.callMutilpleCityWeather), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tblCities.refreshControl = refreshControl
        } else {
            tblCities.addSubview(refreshControl)
        }
        self.tblCities.tableFooterView = UIView()
        self.navigationItem.title = Texts.bookmarkedCity
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.btnAddTapped))
        self.navigationItem.rightBarButtonItem = addBarButton
        let btnClose =  Helper.barButtonItem(selector: #selector(self.btnCloseTapped), controller: self, image: UIImage(named: "close")!)
        self.navigationItem.leftBarButtonItem = btnClose
    }
    @IBAction func btnAddTapped(){
        let vc = self.getNavLocationPickerVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnCloseTapped(){
        self.dismiss(animated: true) {
            
        }
    }
    
    func fetchBookmarkedCities(){
        let cityRecords = self.databaseInstance.getAllCities()
        if let cityQueryRecords = cityRecords {
            self.arrCities = cityQueryRecords
        }
        self.tblCities.reloadData()
    }
}

extension CityListVC{
    func dismissandGotoCityWeather(coordinate: CLLocationCoordinate2D) {
        self.dismiss(animated: true) {
            self.delegate?.updateCityWeatherController(coordinate: coordinate)
        }
    }
}

//MARK: Web Service Calls
extension CityListVC {
    @objc func callMutilpleCityWeather() {
        let ids = self.arrCities.map { "\($0.cityId)" }
        let finalIds = ids.joined(separator: ",")
        let unit = UserDefaults.standard.string(forKey: UnitKey.weatherUnitKey)
        let weatherReq = GroupCityReq(cityId: finalIds, unit: unit)
        print(weatherReq.getParameters())
        DataManager.singleton.getRequest(WebAPI.MultipleCityGroup, params: weatherReq.getParameters())
        { (response: Result<GroupCityRes>) in
            
            switch response {
            case .success(let value):
                print(value)
                self.refreshControl.endRefreshing()
                let arrList = value.list
                
                if arrList.count > 0 {
                    do {
                        for objWeather in arrList {
                            let predicate = NSPredicate(format: "cityId == %d", objWeather.id)
                            let records = self.databaseInstance.dbManager.getRecordsByPredicate(type: City.self, predicate: predicate)
                            
                            if let dbRecords = records, dbRecords.count > 0 {
                                let objFirst = dbRecords.first!
                                try self.databaseInstance.updateCityByGroupResponse(city: objWeather, cityRecord: objFirst)
                            }
                            
                            DispatchQueue.main.async {
                                self.fetchBookmarkedCities()
                            }
                        }
                    }catch { print(error.localizedDescription)}
                }
                else{
                    self.showBanner(title: nil, message: NetworkErrors.noResponseFound, theme: .error, position: .center)
                }
                break
            case .failure(let error):
                self.refreshControl.endRefreshing()
                print(error.localizedDescription)
                self.showBanner(title: nil, message: NetworkErrors.noResponseFound, theme: .error, position: .center)
                break
            }
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension CityListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrCities.count == 0 {
            self.tblCities.setEmptyMessage(Texts.tableEmpty, buttonTitle: Texts.selectCity, selector: #selector(self.btnAddTapped), labelColor:.black, target: self)
        } else {
            self.tblCities.restore()
        }
        return self.arrCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableCell", for: indexPath) as! CityTableCell
        
        let city = self.arrCities[indexPath.row]
        
        cell.lblCity.text = city.cityName
        cell.lblDate.text = Helper.getTime(timeInterval:city.updatedTime, isMinute: true)
        cell.lblTemp.text  = Helper.getTemp(temperature: city.temp)
        
        if let logo = city.logo, !logo.isEmpty{
            let url = URL(string: Helper.getImageUrl(logo: logo))!
            cell.imgWeather.af_setImage(withURL: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = self.arrCities[indexPath.row];
        let coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
        self.dismissandGotoCityWeather(coordinate: coordinate)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.tblCities.beginUpdates()
            try! self.databaseInstance.deleteCity(city: arrCities[indexPath.row])
            self.arrCities.remove(at: indexPath.row)
            self.tblCities.deleteRows(at: [indexPath], with: .fade)
            self.tblCities.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
}
