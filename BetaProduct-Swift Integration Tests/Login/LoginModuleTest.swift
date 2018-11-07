//
//  LoginModuleTest.swift
//  BetaProduct-Swift Integration Tests
//
//  Created by User on 11/23/17.
//  Copyright © 2017 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV_Integration_Tests

// Before you run the test. Change Package in model to allign with this package's(target) name. This is causing type issues. Tried doin access controls but to no avail. possible xcode bug
/// Integration Test class for module `Login`
class LoginModuleTest: XCTestCase, LogInInteractorOutput {
    /// variable for Store
    let store = StoreCoreData()
    /// variable for  Store Web Client
    let webservice = StoreWebClient()
    /// variable for Session
    let session = Session.sharedSession
    /// variable for Login Manager
    var managerLogin : LogInManager?
    /// variable for Create Account Manager
    var managerCreateAccount : CreateAccountManager?
    /// variable for wireframe
    var wireframe : LoginWireframe?
    /// variable for view
    var view : LoginView?
    /// variable for interactor
    var interactor : LogInInteractor?
    /// variable for presenter
    var presenter : LogInPresenter?
    /// variable for expectation
    var expectation : XCTestExpectation? = nil
    /// variable for results
    var result : (isSuccess : Bool, message : String) = (isSuccess : false, message : "")
    
    override func setUp() {
        super.setUp()
        managerCreateAccount = CreateAccountManager()
        managerLogin = LogInManager()
        interactor = LogInInteractor()
        presenter = LogInPresenter()
        wireframe = LoginWireframe()
        view = LoginView()
        
        managerCreateAccount?.store = store
        managerLogin?.store = store
        
        interactor?.webService = webservice
        interactor?.output = self
        interactor?.session = session
        interactor?.managerLogin = managerLogin
        interactor?.managerCreate = managerCreateAccount
        
        presenter?.interactor = interactor
        presenter?.loginWireframe = wireframe
        presenter?.view = view
        
        wireframe?.loginPresenter = presenter
        view?.eventHandler = presenter
    }
    
    override func tearDown() {
        managerLogin = nil
        managerCreateAccount = nil
        interactor = nil
        presenter = nil
        wireframe = nil
        view = nil
        result = (isSuccess : false, message : "")
        super.tearDown()
    }
    
    /// tests behavor if login was successful
    func testSuccessLogin() {
        measure {
            self.expectation = expectation(description: "testSuccessLogin")
            let item = UserDisplayItem(email: "sample@gmail.com", password: "sample")
            view?.eventHandler?.validateUser(item)
            self.waitForExpectations(timeout: 10) { _ in
            }
        }
    }
    
    /// tests behavor if login failed
    func testFailedLogin() {
        // TODO: since webservice always returns true... will do this once rest has improved
    }
    
    // MARK: LogInInteractorOutput
    /// LogInInteractorOutput protocol implementation
    func userLoginValidationComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        result.isSuccess = isSuccess
        result.message = message
        if expectation != nil {
            if expectation?.description == "testSuccessLogin" {
                XCTAssert(result == (true, "Log in success!"), "testSuccessLogin failed")
                XCTAssertNotNil(Session.sharedSession.user)
            }
            expectation?.fulfill()
        }
    }
}
