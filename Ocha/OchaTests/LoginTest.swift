//
//  LoginTest.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/28/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import XCTest
import Firebase
@testable import Ocha

class LoginTest: XCTestCase {
    
    var testLoginPage = ViewController()
    var viewController : ViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name : "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        viewController = navigationController.topViewController as! ViewController
        UIApplication.shared.keyWindow!.rootViewController = viewController
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(viewController.view)
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
    
    /*
    func testEnsureUserInputsCredentials() {
        let username = "staylor8@zagmail.gonzaga.edu"
        let password = " "
        XCTAssertFalse(user.loginByEmail(username, password), "Cannot login if no password")
    }
 */
    
    
    


    
}
