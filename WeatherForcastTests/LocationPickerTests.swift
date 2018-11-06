//
//  LocationPickerTests.swift
//  WeatherForcastTests
//
//  Created by Pratipal on 06/11/18.
//  Copyright © 2018 Pratipalsinh Jadeja. All rights reserved.
//

import XCTest
@testable import WeatherForcast

class LocationPickerTests: XCTestCase {
   var vcLocationPicker: LocationPickerVC!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: LocationPickerVC = storyboard.instantiateViewController(withIdentifier: "LocationPickerVC") as! LocationPickerVC
        vcLocationPicker = vc
        _ = vcLocationPicker.view
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddressLabelNotNil(){
        XCTAssertNotNil(self.vcLocationPicker.addressLabel)
    }
    
    func testGMSMapViewNotNil(){
        XCTAssertNotNil(self.vcLocationPicker.googleMapView)
    }
    
    func testHasCloseButton() {
        XCTAssertNotNil(self.vcLocationPicker.navigationItem.leftBarButtonItem)
    }
    
    func testHasSettingButton() {
        XCTAssertNotNil(self.vcLocationPicker.navigationItem.rightBarButtonItem)
    }
    
    func testCloseButtonActionAssigned() {
        
        if let leftBarButtonItem = self.vcLocationPicker.navigationItem.leftBarButtonItem {
            guard let btnClose = leftBarButtonItem.customView as? UIButton else {
                XCTFail("No CustomView found in leftBarButtonItem");
                return
            }
            let actionMethod = btnClose.actions(forTarget: self.vcLocationPicker, forControlEvent: .touchUpInside)
            let actualMethodName = actionMethod?.first
            let expectedMethodName = "btnCloseTapped"
            XCTAssertEqual(actualMethodName, expectedMethodName, "No Action found in Close Button")
        }
        else {
            XCTAssertTrue(false, "Home Controller has no Setting button")
        }
    }
    
    func testSearchButtonActionAssigned() {
        
        if let rightBarButtonItem = self.vcLocationPicker.navigationItem.rightBarButtonItem {
            guard let btnSearch = rightBarButtonItem.customView as? UIButton else {
                XCTFail("No CustomView found in rightBarButtonItem");
                return
            }
            let actionMethod = btnSearch.actions(forTarget: self.vcLocationPicker, forControlEvent: .touchUpInside)
            let actualMethodName = actionMethod?.first
            let expectedMethodName = "searchBtnTapped:"
            XCTAssertEqual(actualMethodName, expectedMethodName, "No Action found in Search Button")
        }
        else {
            XCTAssertTrue(false, "Controller has no Search button")
        }
    }

}
