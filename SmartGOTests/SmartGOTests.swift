//
//  SmartGOTests.swift
//  SmartGOTests
//
//  Created by thanh tuan on 6/23/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import XCTest

@testable import SmartGO

class SmartGOTests: XCTestCase {
    var listeningController: ListeningController? = nil
    override func setUp() {
        super.setUp()
        listeningController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listeningcontroller") as? ListeningController

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
