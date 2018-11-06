//
//  SettingTests.swift
//  WeatherForcastTests
//
//  Created by Pratipal on 06/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import XCTest
@testable import WeatherForcast
class SettingTests: XCTestCase {
    var vcSetting: SettingsVC!
    var mockDelegate: MockUpdateCitySettingDelegate!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: SettingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        
        vcSetting = vc
        _ = vcSetting.view
        mockDelegate = MockUpdateCitySettingDelegate()
    }

    func testSettingDelegateCalled() {
        vcSetting.delegate = mockDelegate
        vcSetting.callWeatherDetailVCDelegate(isRemoveData: true)
        XCTAssertTrue(mockDelegate.viewController! is SettingsVC)
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
