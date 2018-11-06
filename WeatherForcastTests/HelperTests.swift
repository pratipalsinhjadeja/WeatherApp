//
//  HelperTests.swift
//  WeatherForcastTests
//
//  Created by Pratipal on 06/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import XCTest
@testable import WeatherForcast

class HelperTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetTemp() {
        let temp = Helper.getTemp(temperature: 31.8)
        XCTAssertEqual(temp, "\(31.8)\u{00B0}")
        
    }
    
    func testGetPresure() {
        let presure = Helper.getPresure(presure: 1100)
        XCTAssertEqual(presure, "\(1100) hPa")
        
    }
    
    func testGetPercentage() {
        let rainChances = Helper.getPercentage(value: 0)
        XCTAssertEqual(rainChances, "\(0)%")
    }
    
    
    func testGetWind() {
        let wind = Helper.getWind(degrees: 10, speed: 1.5)
        XCTAssertEqual(wind, "N \(1.5) km/hr")
    }
    
    func testWindDirection(){
        let windDirection = Helper.windDirection(degrees: 10)
        XCTAssertEqual(windDirection, "N")
    }
    
    func testGetTime(){
        let time = Helper.getTime(timeInterval: 1539998667, isMinute: false)
        XCTAssertEqual(time, "06 AM")
    }
    
    func testMainStoryBoardNotNil(){
        XCTAssertNotNil(MockViewController().mainStoryboard())
    }
    
    func testGetNavCityListVCNotNil(){
        XCTAssertNotNil(MockViewController().getNavCityListVC())
    }
    
    func testgetNavLocationPickerVCNotNil(){
        XCTAssertNotNil(MockViewController().getNavLocationPickerVC())
    }
    
//    func testGetNavAboutAppVCNotNil(){
//        XCTAssertNotNil(MockViewController().getNavAboutAppVC())
//    }
    
    func testGetNavSettingsVCNotNil(){
        XCTAssertNotNil(MockViewController().getNavSettingsVC)
    }
    
    
}
