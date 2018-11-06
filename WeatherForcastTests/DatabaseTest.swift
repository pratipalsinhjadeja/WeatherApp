//
//  DatabaseTest.swift
//  WeatherForcastTests
//
//  Created by Pratipal on 06/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import XCTest
@testable import WeatherForcast

class DatabaseTest: XCTestCase {
    
    override func setUp() {
        
        DataOperation.singleton.getObjectContex()
        try! DataOperation.singleton.deleteAllCities()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        
        try! DataOperation.singleton.deleteAllCities()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func loadJson(fileName: String) -> Data?{
        guard let pathString = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            fatalError("\(fileName).json not found")
        }
        
        let url = URL(fileURLWithPath: pathString)
        let data = try! Data(contentsOf: url)
        return data
    }
    
    func addOneCity() -> City{
        let jsonData = self.loadJson(fileName: "CurrentWeather")
        let jsonDecoder = JSONDecoder()

        var currentWeatherRes = try! jsonDecoder.decode(CurrentWeatherRes.self, from: jsonData!)
        currentWeatherRes.name = "CustomCity"
        let city  = try! DataOperation.singleton.addCity(response: currentWeatherRes)
        return city!
        
    }
    
    func testInitDataOperation(){
        let instance = DataOperation.singleton
        XCTAssertNotNil( instance )
    }
    
    func testPersistantCoordinatorNotNil() {
        let coreDataStack = DataOperation.singleton.dbManager.managedObjectContext.persistentStoreCoordinator
        XCTAssertNotNil( coreDataStack )
    }
    

    
    func testAddCity(){
        let jsonData = self.loadJson(fileName: "CurrentWeather")
        let jsonDecoder = JSONDecoder()
        do {
            let currentWeatherRes = try jsonDecoder.decode(CurrentWeatherRes.self, from: jsonData!)
            for _ in 1...5 {
                let city  = try! DataOperation.singleton.addCity(response: currentWeatherRes)
                XCTAssertNotNil(city)
            }
            let results = DataOperation.singleton.getAllCities()
            XCTAssertEqual(results?.count, 5)
        } catch  {
            XCTFail()
        }
    }
    
    func testDeleteCity() {
        let results = DataOperation.singleton.getAllCities()
        
        if let cities = results, cities.count > 0 {
            let city = cities[0]
            let countOfCities = cities.count
            try! DataOperation.singleton.deleteCity(city: city)
            
            XCTAssertEqual(DataOperation.singleton.getAllCities()?.count, countOfCities - 1)
        }else{
            
            XCTAssertTrue(results?.count == 0)
        }
    }
    
    func testDeleteAllCities() {

        let results = DataOperation.singleton.getAllCities()
        XCTAssertEqual(results?.count, 0)
    }
    
    func testUpdateCity(){
        
        let jsonData = self.loadJson(fileName: "CurrentWeather")
        let jsonDecoder = JSONDecoder()
        
        do {
            var currentWeatherRes = try jsonDecoder.decode(CurrentWeatherRes.self, from: jsonData!)
            let city  = try! DataOperation.singleton.addCity(response: currentWeatherRes)
            XCTAssertNotNil(city)
            
            currentWeatherRes.name = "Rajkot"
            
            let results = DataOperation.singleton.getAllCities()
            if let cities = results, cities.count > 0 {
                let city = cities[0]
                try! DataOperation.singleton.updateCity(response: currentWeatherRes, categoryDB: city)
            }else{
                XCTFail()
            }
            
            let updatedCities = DataOperation.singleton.getAllCities()
            if let cities = updatedCities, cities.count > 0 {
                let city = cities[0]
                XCTAssertEqual(city.cityName, "Rajkot")
            }else{
                XCTFail()
            }
        } catch  {
            XCTFail()
        }
    }
    

    func testUpdateCityByGroup()  {
        
        let jsonData = self.loadJson(fileName: "cityGroup")
        let jsonDecoder = JSONDecoder()
        
        do {
            // Add One city  of ID 1279233
            let city = self.addOneCity()
            let cityName = city.cityName
            
            let cityGroupRes = try jsonDecoder.decode(GroupCityRes.self, from: jsonData!)
            for weatherForcast in cityGroupRes.list {
                try! DataOperation.singleton.updateCityByGroupResponse(city: weatherForcast, cityRecord: city)
            }
            
           let isFound =  DataOperation.singleton.getAllCities()?.contains(where: { $0.cityName == cityName })
            XCTAssertEqual(isFound, false)
            
        } catch  {
            XCTFail()
        }
    }
}
