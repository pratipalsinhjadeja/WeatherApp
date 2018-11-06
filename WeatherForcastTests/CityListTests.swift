//
//  CityListTests.swift
//  WeatherForcastTests
//
//  Created by Pratipal on 06/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import XCTest
@testable import WeatherForcast
class CityListTests: XCTestCase {
    var vcCityList: CityListVC!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: CityListVC = storyboard.instantiateViewController(withIdentifier: "CityListVC") as! CityListVC
        
        vcCityList = vc
        _ = vcCityList.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testtblCityNotNil(){
        XCTAssertNotNil(self.vcCityList.tblCities)
    }
    func testBtnAddNotNil(){
        XCTAssertNotNil(self.vcCityList.navigationItem.rightBarButtonItem!)
    }
    
    func testBtnAddButtonActionAssigned() {
        
        if let rightBarButtonItem = self.vcCityList.navigationItem.rightBarButtonItem {
            XCTAssertTrue(rightBarButtonItem.action!.description == "btnAddTapped")
        }
        else {
            
            XCTAssertTrue(false)
        }
       
    }
}
