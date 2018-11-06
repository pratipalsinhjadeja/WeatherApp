//
//  CityWeatherDetailTests.swift
//  WeatherForcastTests
//
//  Created by Pratipal on 05/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import XCTest
import Alamofire

@testable import WeatherForcast

class CityWeatherDetailTests: XCTestCase {
    
    
    var vcDetail: CityWeatherDetailVC!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: CityWeatherDetailVC = storyboard.instantiateViewController(withIdentifier: "CityWeatherDetailVC") as! CityWeatherDetailVC
        
        vcDetail = vc
        _ = vcDetail.view
    }
    
    func loadJson(fileName: String) -> Data?{
        guard let pathString = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            fatalError("\(fileName).json not found")
        }
        
        let url = URL(fileURLWithPath: pathString)
        let data = try! Data(contentsOf: url)
        return data
        
    }
    
    func testDayLabelNotNil(){
        XCTAssertNotNil(self.vcDetail.lblDay)
    }
    
    func testCityLabelNotNil(){
        XCTAssertNotNil(self.vcDetail.lblCity)
    }
    
    func testTempLabelNotNil(){
        XCTAssertNotNil(self.vcDetail.lblTemp)
    }
    
    func testMinTempLabelNotNil(){
        XCTAssertNotNil(self.vcDetail.lblMinTemp)
    }
    
    func testMaxTempLabelNotNil(){
        XCTAssertNotNil(self.vcDetail.lblMaxTemp)
    }
    
    func testWeatherTabelViewNotNil(){
        XCTAssertNotNil(self.vcDetail.tblWeatherDetails)
    }
    
    func testWeatherTableViewDelegate() {
        XCTAssertNotNil(self.vcDetail.tblWeatherDetails.delegate, "WeatherDetail TableView has no delegate assigned")
    }
    
    func testWeatherTableViewDataSource() {
        XCTAssertNotNil(self.vcDetail.tblWeatherDetails.dataSource, "WeatherDetail TableView has no datasource assigned")
    }
    
    func testVCConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(self.vcDetail.conforms(to: UITableViewDelegate.self))
    }
    
    func testVCConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(self.vcDetail.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(self.vcDetail.responds(to: #selector(self.vcDetail.numberOfSections(in:))))
        XCTAssertTrue(self.vcDetail.responds(to: #selector(self.vcDetail.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(self.vcDetail.responds(to: #selector(self.vcDetail.tableView(_:cellForRowAt:))))
    }
    
    func testWeatherTableHasTwoSections(){
        let sectionCount = self.vcDetail.tblWeatherDetails.numberOfSections
        XCTAssertEqual(sectionCount, 2)
    }
    
    func testWeatherTableFirstSectionHasOneRow(){
        let rowsCount = self.vcDetail.tblWeatherDetails.numberOfRows(inSection: 0)
        XCTAssertEqual(rowsCount, 1)
    }
    
    func testWeatherTableSecondSectionHasFiveRow(){
        
        let jsonData = self.loadJson(fileName: "CurrentWeather")
        let jsonDecoder = JSONDecoder()
        do {
            let currentWeatherRes = try jsonDecoder.decode(CurrentWeatherRes.self, from: jsonData!)
            self.vcDetail.objWeatherData = currentWeatherRes
            
            self.vcDetail.createExtendedDetailModels()
            self.vcDetail.tblWeatherDetails.reloadData()
            let rowsCount = self.vcDetail.tblWeatherDetails.numberOfRows(inSection: 1)
            
            XCTAssertEqual(rowsCount, self.vcDetail.arrExtendedInfo.count)
        } catch  {
            XCTFail()
        }
    }
    
    func testTableViewCellHasForcastTableCellReuseIdentifier() {
        let jsonData = self.loadJson(fileName: "CurrentWeather")
        let jsonDecoder = JSONDecoder()
        do {
            let currentWeatherRes = try jsonDecoder.decode(CurrentWeatherRes.self, from: jsonData!)
            self.vcDetail.objWeatherData = currentWeatherRes
            
            self.vcDetail.createExtendedDetailModels()
            self.vcDetail.tblWeatherDetails.reloadData()
            let cell = self.vcDetail.tableView(self.vcDetail.tblWeatherDetails, cellForRowAt: IndexPath(row: 0, section: 0))
            let actualReuseIdentifer = cell.reuseIdentifier
            let expectedReuseIdentifier = "ForcastTableCell"
            XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
        } catch  {
            XCTFail()
        }
    }
    
    func testTableViewCellHasWeatherExtendedInfoCellReuseIdentifier() {
        let jsonData = self.loadJson(fileName: "CurrentWeather")
        let jsonDecoder = JSONDecoder()
        do {
            let currentWeatherRes = try jsonDecoder.decode(CurrentWeatherRes.self, from: jsonData!)
            self.vcDetail.objWeatherData = currentWeatherRes
            
            self.vcDetail.createExtendedDetailModels()
            self.vcDetail.tblWeatherDetails.reloadData()
            let cell = self.vcDetail.tableView(self.vcDetail.tblWeatherDetails, cellForRowAt: IndexPath(row: 0, section: 1))
            let actualReuseIdentifer = cell.reuseIdentifier
            let expectedReuseIdentifier = "WeatherExtendedInfoCell"
            XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
        } catch  {
            XCTFail()
        }
    }
    
    func testCurrentWeatherAPI(){
        let exep = expectation(description: WebAPI.TodayForcast)
        let weatherReq = CurrentWeatherReq(lat:23.0225 , lon:72.5714 , unit:WeatherUnits.Metric.rawValue)
        DataManager.singleton.getRequest(WebAPI.TodayForcast, params: weatherReq.getParameters())
        { (response: Result<CurrentWeatherRes>) in
            
            switch response {
            case .success(let value):
                if value.cod == 200 {
                    exep.fulfill()
                }
                else{
                    XCTFail()
                }
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
                break
            }
        }
        waitForExpectations(timeout: 10.0) { (_) in
        }
    }
    
    func testForcastWeather(){
        let exep = expectation(description: WebAPI.FiveDaysForcast)
        let weatherReq = CurrentWeatherReq(lat:23.0225, lon:72.5714, unit:WeatherUnits.Metric.rawValue)
        
        DataManager.singleton.getRequest(WebAPI.FiveDaysForcast, params: weatherReq.getParameters())
        { (response: Result<ForcastWeatherRes>) in
            
            switch response {
            case .success(let value):
                
                let weatherData: ForcastWeatherRes = value
                if weatherData.cod == 200 {
                    exep.fulfill()
                }
                else{
                    XCTFail()
                }
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
                break
            }
        }
        waitForExpectations(timeout: 5.0) { (_) in
        }
    }
    func testLoadForcastCellCollectionViewNotNil(){
        self.vcDetail.tblWeatherDetails.reloadData()
        let cell: ForcastTableCell = self.vcDetail.tableView(self.vcDetail.tblWeatherDetails, cellForRowAt: IndexPath(row: 0, section: 0)) as! ForcastTableCell
        XCTAssertNotNil(cell.cvForcast)
    }
    
    func testLoadForcastCellDataAssigned(){
        
        let jsonData = self.loadJson(fileName: "forcastWeather")
        let jsonDecoder = JSONDecoder()
        do {
            let forcastWeatherRes = try jsonDecoder.decode(ForcastWeatherRes.self, from: jsonData!)
            self.vcDetail.arrForcast = forcastWeatherRes.list
            
            self.vcDetail.tblWeatherDetails.reloadData()
            let cell: ForcastTableCell = self.vcDetail.tableView(self.vcDetail.tblWeatherDetails, cellForRowAt: IndexPath(row: 0, section: 0)) as! ForcastTableCell
            
            let numberOfItems = cell.cvForcast.numberOfItems(inSection: 0)
            
            XCTAssertEqual(numberOfItems, forcastWeatherRes.list.count)
            
        } catch  {
            XCTFail()
        }
        
    }
}
