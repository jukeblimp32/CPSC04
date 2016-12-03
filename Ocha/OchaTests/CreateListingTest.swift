//
//  CreateListingTest.swift
//  Ocha
//
//  Created by Talkov, Leah C on 12/2/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import XCTest
@testable import Ocha


class CreateListingTest: XCTestCase {
    
    var testListingPage : CreateListing!
    
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
    
    func testNoNullListingsGoToDatabase() {
        let address = testListingPage.address.text
        XCTAssertFalse("" == address)
        let deposit = testListingPage.deposit.text
        XCTAssertFalse("" == deposit)
        let tenantNumber = testListingPage.tenantNumber.text
        XCTAssertFalse("" == tenantNumber)
        let bedroomNumber = testListingPage.bedroomNumber.text
        XCTAssertFalse("" == bedroomNumber)
        let bathroomNumber = testListingPage.bathroomNumber.text
        XCTAssertFalse("" == bathroomNumber)
        let distance = testListingPage.milesToGU.text
        XCTAssertFalse("" == distance)
        let leaseLength = testListingPage.leaseLength.text
        XCTAssertFalse("" == leaseLength)
    }
    
}
