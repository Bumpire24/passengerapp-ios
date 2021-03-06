//
//  BetaProduct_Swift_DEVUITests.swift
//  BetaProduct-Swift DEVUITests
//
//  Created by User on 11/23/17.
//  Copyright © 2017 User. All rights reserved.
//

import XCTest

class BetaProduct_Swift_DEVUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        app.buttons["Create account"].tap()
        app.navigationBars["BetaProduct_Swift_DEV.CreateAccountView"].buttons["Back"].tap()
        
        let loginButton = app.buttons["Login"]
        loginButton.tap()
        loginButton.tap()
        app.buttons["OK"].tap()
        app.navigationBars["BetaProduct_Swift_DEV.LoginView"].buttons["Back"].tap()
        
        
    }
    
}
