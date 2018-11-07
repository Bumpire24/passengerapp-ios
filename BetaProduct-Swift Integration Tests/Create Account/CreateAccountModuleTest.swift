//
//  CreateAccountModuleTest.swift
//  BetaProduct-Swift Integration Tests
//
//  Created by User on 11/27/17.
//  Copyright © 2017 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV_Integration_Tests

// Before you run the test. Change Package in model to allign with this package's(target) name. This is causing type issues. Tried doin access controls but to no avail. possible xcode bug
/// Integration Test class for module `Create Account`
class CreateAccountModuleTest: XCTestCase, CreateAccountViewProtocol {
    /// variable for Store
    let store = StoreCoreData()
    /// variable for  Store Web Client
    let webservice = StoreWebClient()
    /// variable for Create Account Manager
    var manager : CreateAccountManager?
    /// variable for wireframe
    var wireframe : CreateAccountWireframe?
    /// variable for view
    var view : CreateAccountView?
    /// variable for interactor
    var interactor : CreateAccountInteractor?
    /// variable for presenter
    var presenter : CreateAccountPresenter?
    /// variable for expectation
    var expectation : XCTestExpectation? = nil
    /// variable for results
    var result : (isSuccess : Bool, message : String) = (isSuccess : false, message : "")
    
    override func setUp() {
        super.setUp()
        manager = CreateAccountManager()
        interactor = CreateAccountInteractor()
        presenter = CreateAccountPresenter()
        wireframe = CreateAccountWireframe()
        view = CreateAccountView()
        
        manager?.store = store
        
        interactor?.createAccountManager = manager
        interactor?.webService = webservice
        interactor?.output = presenter
        
        presenter?.interactor = interactor
        presenter?.wireframeCreateAccount = wireframe
        presenter?.view = self
        
        wireframe?.presenter = presenter
        view?.eventHandler = presenter
    }
    
    override func tearDown() {
        manager = nil
        interactor = nil
        presenter = nil
        wireframe = nil
        view = nil
        result = (isSuccess : false, message : "")
        super.tearDown()
    }
    
    /// tests behavor if account creation was successful
    func testCreateAccountSuccess() {
        self.expectation = expectation(description: "testCreateAccountSuccess")
        let item = UserCredentialsItem.init(lastName: "SampleLast",
                                            firstName: "SampleFirst",
                                            middleName: "SampleMiddle",
                                            shippingAddress: "SampleAdd",
                                            mobileNumber: "123456789",
                                            email: "sample@sample.com",
                                            password: "sample")
        view?.eventHandler?.validateUserCredentials(item)
        self.waitForExpectations(timeout: 10) { _ in
        }
    }
    
    /// tests behavor if account creation failed
    func testCreateAccountFail() {
        // since same has account has already been created
        self.expectation = expectation(description: "testCreateAccountFail")
        let item = UserCredentialsItem.init(lastName: "SampleLast",
                                            firstName: "SampleFirst",
                                            middleName: "SampleMiddle",
                                            shippingAddress: "SampleAdd",
                                            mobileNumber: "123456789",
                                            email: "sample@sample.com",
                                            password: "sample")
        view?.eventHandler?.validateUserCredentials(item)
        self.waitForExpectations(timeout: 10) { _ in
        }
    }
    
    // MARK: CreateAccountViewProtocol
    /// protocol implementation. see `CreateAccountViewProtocol.swift`
    func displayMessage(_ message: String, wasAccountCreationSuccesful wasSuccessful: Bool) {
        result.isSuccess = wasSuccessful
        result.message = message
        if expectation != nil {
            if expectation?.description == "testCreateAccountSuccess" {
                XCTAssert(result == (true, "Account creation Successful!"), "testCreateAccountSuccess failed")
            }
            expectation?.fulfill()
        }
    }
}
