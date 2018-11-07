//
//  WebServiceTest.swift
//  BetaProduct-Swift Unit Tests
//
//  Created by User on 11/27/17.
//  Copyright © 2017 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV

/// test service class for service `StoreWebClient`
class WebServiceTest: XCTestCase {

    override func setUp() {
        super.setUp()

    }

    override func tearDown() {

        super.tearDown()
    }
    
    /// test performance
    func testPerformance() {
        self.measureMetrics([XCTPerformanceMetric.wallClockTime], automaticallyStartMeasuring: false) {
            startMeasuring()
            StoreWebClient().GET(iDooh.kWSProducts(), parameters: nil) { _ in
                self.stopMeasuring()
            }
        }
    }

    /// test GET behavior
    func testGetFunctionality() {
        let expectation : XCTestExpectation = self.expectation(description: "testGetFunctionality")
        StoreWebClient().GET(iDooh.kWSProducts(), parameters: nil) { response in
            guard let data = response.value?.first, let datadict = data as? [String : Any?] else {
                XCTFail("testGetFunctionality failed")
                expectation.fulfill()
                return
            }
            
            XCTAssert(datadict["id"] != nil, "testGetFunctionality failed")
            XCTAssert(datadict["name"] != nil, "testGetFunctionality failed")
            XCTAssert(datadict["description"] != nil, "testGetFunctionality failed")
            XCTAssert(datadict["price"] != nil, "testGetFunctionality failed")
            XCTAssert(datadict["currency"] != nil, "testGetFunctionality failed")
            XCTAssert(datadict["image_thumbnail_url"] != nil, "testGetFunctionality failed")
            XCTAssert(datadict["image_high_res_url"] != nil, "testGetFunctionality failed")
            expectation.fulfill()
        }
        self.waitForExpectations(timeout: 5.0) { _ in
        }
    }

    // TODO: UnComment Post, Put and Patch and find a userid that can be tested before running this test
    
    /// test POST behavior
    func testPostFunctionality() {
//        let expectation : XCTestExpectation = self.expectation(description: "testPostFunctionality")
//        var data = [String: Any]()
//        data["first_name"] = "samplefirst"
//        data["middle_name"] = "samplemiddle"
//        data["last_name"] = "samplelast"
//        data["email"] = "sample@samplesample.com"
//        data["shipping_address_1"] = "shippinaddress"
//        data["password"] = "password"
//        StoreWebClient().POST(iDooh.kWSUsers(), parameters: data) { response in
//            guard let data = response.value?.first, let _ = data as? [String : Any?] else {
//                XCTFail("testPostFunctionality failed")
//                expectation.fulfill()
//                return
//            }
//            XCTAssertTrue(response.isSuccess, "testPostFunctionality failed")
//            expectation.fulfill()
//        }
//        self.waitForExpectations(timeout: 5.0) { _ in
//        }
    }
    
    /// test PUT behavior
    func testPutFunctionality() {
//        let expectation : XCTestExpectation = self.expectation(description: "testPutFunctionality")
//        var data = [String: Any]()
//        data["first_name"] = "samplefirst"
//        data["middle_name"] = "samplemiddle"
//        data["last_name"] = "samplelast"
//        data["email"] = "sample@samplesample.com"
//        data["shipping_address_1"] = "shippinaddress"
//        data["password"] = "password"
//        StoreWebClient().PUT(iDooh.kWSUsers(withID: "1"), parameters: data) { response in
//            guard let data = response.value?.first, let datadict = data as? [String : Any?] else {
//                XCTFail("testPutFunctionality failed")
//                expectation.fulfill()
//                return
//            }
//
//            XCTAssert(datadict["id"] != nil, "testPutFunctionality failed")
//            expectation.fulfill()
//        }
//        self.waitForExpectations(timeout: 5.0) { _ in
//        }
    }

    /// test PATCH behavior
    func testPatchFunctionality() {
//        var data = [String: Any]()
//        data["first_name"] = "samplefirst"
//        data["shipping_address_1"] = "shippinaddress"
//        let expectation : XCTestExpectation = self.expectation(description: "testPatchFunctionality")
//        StoreWebClient().PUT(iDooh.kWSUsers(withID: "1"), parameters: data) { response in
//            guard let data = response.value?.first, let datadict = data as? [String : Any?] else {
//                XCTFail("testPatchFunctionality failed")
//                expectation.fulfill()
//                return
//            }
//
//            XCTAssert(datadict["id"] != nil, "testPatchFunctionality failed")
//            expectation.fulfill()
//        }
//        self.waitForExpectations(timeout: 5.0) { _ in
//        }
    }
}

