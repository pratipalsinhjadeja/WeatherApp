//
//  DataOperation.swift
//  WeatherForcast
//
//  Created by Pratipalsinh on 05/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import Foundation
import CoreData

class DataOperation {
    
    static let singleton = DataOperation()
    
    let dbManager = WeatherData(modelName: "WeatherForcast")
    var managedObjectContext : NSManagedObjectContext? = nil
    
    private init() {}
    
    func getObjectContex() {
        managedObjectContext = dbManager.managedObjectContext
    }
    
    func getAllCities() -> [City]? {
        
        let cityRecords = self.dbManager.getRecords(type: City.self)
        return cityRecords
    }
    
    func addCity(response: CurrentWeatherRes) throws -> City? {
        
        guard let managedObjectContext = managedObjectContext else {
            return nil
        }
        
        guard let addRecord = dbManager.insertRecord(type: City.self) else {
            return nil
        }
        
        let addRecordDB = addRecord
        
        addRecordDB.cityId = Int32(response.id)
        addRecordDB.cityName = response.name
        addRecordDB.latitude = response.coord.lat
        addRecordDB.longitude = response.coord.lon
        addRecordDB.updatedTime = response.dt
        if let objWeather = response.weather.first {
            addRecordDB.logo = objWeather.icon
        }
        addRecordDB.temp = response.main.temp
        
        try managedObjectContext.save()
        
        return addRecordDB
    }
    
    func updateCity(response: CurrentWeatherRes, categoryDB: City) throws {
        
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        let updateRecord = categoryDB
        
        updateRecord.cityName = response.name
        updateRecord.latitude = response.coord.lat
        updateRecord.longitude = response.coord.lon
        updateRecord.updatedTime = response.dt
        if let objWeather = response.weather.first {
            updateRecord.logo = objWeather.icon
        }
        updateRecord.temp = response.main.temp
        
        try managedObjectContext.save()
    }
    
    func updateCityByGroupResponse(city: WeatherForcast, cityRecord: City) throws {
        
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        let updateRecord = cityRecord
        updateRecord.cityName = city.name
        updateRecord.updatedTime = city.dt
        updateRecord.temp = city.main.temp
        if let objWeather = city.weather.first {
            updateRecord.logo = objWeather.icon
        }
        
        try managedObjectContext.save()
    }
    func deleteCity(city: City) throws {
        
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        managedObjectContext.delete(city)
        
        try managedObjectContext.save()
        
    }
    
    func deleteAllCities() throws {
        
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        guard let cities = dbManager.getRecords(type: City.self) else {
            return
        }
        
        for city in cities {
            managedObjectContext.delete(city)
        }
        
        try managedObjectContext.save()
    }
}
