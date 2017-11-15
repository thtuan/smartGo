//
//  HomeScreenTest.swift
//  SmartGOTests
//
//  Created by thanh tuan on 11/15/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import XCTest
@testable import SmartGO
class HomeScreenTest: XCTestCase {
    var homeController: HomeController? = nil
//    var homePresenter: HomePresenter?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        homeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homecontroller") as? HomeController
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testController() {
//        XCTAssertNotNil(homePresenter, "home presenter nil")
//        XCTAssertNotNil(homeController?.presenter, "home presenter in controller nil")
        XCTAssertNotNil(homeController?.outstandingData, "home outstandingData nil")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testPresenterGetDataOutstanding() {
        let homePresenter = HomePresenter()
        homePresenter.interactor = HomeInteractor()
        homePresenter.interactor.getOutstandingTopic(dataResponse: { data in
            XCTAssertNotNil(data, "outstanding data nil")
            XCTAssertTrue(data.count > 0, "outstanding data nil")
        })
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testPresenterGetDataTodayTopic() {
        let homePresenter = HomePresenter()
        homePresenter.interactor = HomeInteractor()
        homePresenter.interactor.getTodayTopic { data in
            XCTAssertNotNil(data.data,"today topic data not nil")
            XCTAssertNil(data.data?.imageURL, "image url not nil")
            XCTAssertNotNil(data.data?.name, "name not nil")
//            XCTAssertNotNil(data.data?.describe, "describe not nil")
//            XCTAssertNotNil(data.data?.link, "link not nil")
        }
    }
    func testPerformanceGetData() {
        // This is an example of a performance test case.
        self.measure {
            self.testPresenterGetDataOutstanding()
            self.testPresenterGetDataTodayTopic()
            // Put the code you want to measure the time of here.
        }
    }
    
}
