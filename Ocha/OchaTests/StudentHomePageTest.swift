//
//  StudentHomePageTest.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/28/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import XCTest
@testable import Ocha

class StudentHomePageTest: XCTestCase {
    
    var testHomePage : StudentHomePage!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name : "Main", bundle: Bundle(for: self.classForCoder))
        testHomePage = storyboard.instantiateViewController(withIdentifier: "StudentHomePage") as! StudentHomePage
        testHomePage.loadView()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        XCTAssertNotNil(testHomePage)

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        XCTAssert(true)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testEnsureDatabaseTablesAreNotNull() {
        
       // testHomePage.loadListingViews()
        //let x = testHomePage.listings.count
        //XCTAssertFalse(0 == x)
    }
}
