//
//  CityListVC.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 05/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import UIKit
import CoreLocation

protocol UpdateCityWeatherDelegate {
    func updateCityWeatherController(coordinate: CLLocationCoordinate2D)
}

class CityListVC: UIViewController {
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var tblCities: UITableView!
    let databaseInstance = DataOperation.singleton
    var arrCities = [City]()
    var refreshControl = UIRefreshControl()
    var delegate: UpdateCityWeatherDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        // Do any additional setup after loading the view.
        self.fetchBookmarkedCities()
    }
    
    func setupViews(){
    
        //refreshControl.addTarget(self, action: #selector(self.fetchWeatherInfo), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tblCities.refreshControl = refreshControl
        } else {
            tblCities.addSubview(refreshControl)
        }
        
        self.navigationItem.title = Texts.bookmarkedCity
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.btnAddTapped))
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    @IBAction func btnAddTapped(){
        let vc = self.getNavLocationPickerVC()
        let locationVC: LocationPickerVC = vc.viewControllers.first! as! LocationPickerVC
        locationVC.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func fetchBookmarkedCities(){
        let cityRecords = self.databaseInstance.getAllCities()
        if let cityQueryRecords = cityRecords {
            self.arrCities = cityQueryRecords
        }
        self.tblCities.reloadData()
    }
    
    func callGroupedCityWeather(){
        
    }
}

extension CityListVC: LocationPickerDelegate{
    func selectedCity(coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension CityListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrCities.count == 0 {
            self.tblCities.setEmptyMessage(Texts.tableEmpty, buttonTitle: Texts.selectCity, selector: #selector(self.btnAddTapped), target: self)
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
        self.dismiss(animated: true) {
            self.delegate.updateCityWeatherController(coordinate: coordinate)
        }
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
