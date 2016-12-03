//
//  SearchAndFilterTest.swift
//  Ocha
//
//  Created by Talkov, Leah C on 12/2/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import XCTest

class SearchAndFilterTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
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
    
    func testQueriesLoadCorrectListings() {
        let queries = ["3 miles", "500 rent"]
        let listings = searchQueries.findListings(queries)
        for list in listings {
            for query in queries {
                XCTAssertTrue(list.contains(query), "The desired query is not in this listing")
            }
        }
    }
    
}
