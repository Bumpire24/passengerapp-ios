//
//  CreateAccountInteractorTest.swift
//  BetaProduct-Swift Unit Tests
//
//  Created by User on 11/24/17.
//  Copyright © 2017 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV

/// test interactor class for module `create account`
class CreateAccountInteractorTest: XCTestCase, CreateAccountInteractorOutput {
    /// variable for result. Shared variable for class and delegate
    var result : (isSuccess : Bool, message : String) = (isSuccess : false, message : "")
    /// variable for interactor
    var interactor : CreateAccountInteractor?
    /// variable for expectation
    var expectation : XCTestExpectation? = nil
    
    override func setUp() {
        super.setUp()
        interactor = CreateAccountInteractor()
        interactor?.output = self
    }
    
    override func tearDown() {
        interactor = nil
        expectation = nil
        super.tearDown()
    }
    
    // use case
    // validate Account Credentials
    // retrieve account with the given input
    // check email nil, email whitespace, valid email
    // check password nil, password whitespace
    // call WS
    // check account if valid for creation
    
    /// tests create account if email is nil
    func testInputNil() {
        let item = UserCredentialsItem.init(lastName: "Last",
                                            firstName: "First",
                                            middleName: "Middle",
                                            shippingAddress: "Sample",
                                            mobileNumber: "123456789",
                                            email: nil,
                                            password: "sample")
        interactor?.validateAccountCredentials(item)
        XCTAssert(result == (false, "Email incorrect!"), "testInputNil Failed")
    }
    
    /// tests create account if email has whitespaces
    func testInputWhiteSpace() {
        let item = UserCredentialsItem.init(lastName: "Last",
                                            firstName: "First",
                                            middleName: "Middle",
                                            shippingAddress: "Sample",
                                            mobileNumber: "123456789",
                                            email: "",
                                            password: "sample")
        interactor?.validateAccountCredentials(item)
        XCTAssert(result == (false, "Email incorrect!"), "testInputWhiteSpace Failed")
    }
    
    /// tests create account if email does not follow correct pattern
    func testUsernameIncorrectPattern() {
        let item = UserCredentialsItem.init(lastName: "Last",
                                            firstName: "First",
                                            middleName: "Middle",
                                            shippingAddress: "Sample",
                                            mobileNumber: "123456789",
                                            email: "",
                                            password: "sample")
        interactor?.validateAccountCredentials(item)
        XCTAssert(result == (false, "Email incorrect!"), "testUsernameIncorrectPattern Failed")
    }
    
    /// tests if account creation successful
    func testAccountCreationSuccess() {
        class MockWebservice : StoreWebClient {
            override func POST(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
                block(.success([]))
            }
        }
        
        self.expectation = expectation(description: "testAccountCreationSuccess")
        let item = UserCredentialsItem.init(lastName: "Last",
                                            firstName: "First",
                                            middleName: "Middle",
                                            shippingAddress: "Sample",
                                            mobileNumber: "123456789",
                                            email: "sample@sample.com",
                                            password: "sample")
        interactor?.webService = MockWebservice()
        interactor?.validateAccountCredentials(item)
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    func testAccountCreationFails() {
        class MockWebservice : StoreWebClient {
            override func POST(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
                let error = iDoohError.init(domain: iDooh.kErrorDomain,
                                            code: .WebService,
                                            description: "",
                                            reason: "Email is already in use!",
                                            suggestion: "")
                block(.failure(error))
            }
        }
        
        self.expectation = expectation(description: "testAccountCreationFails")
        let item = UserCredentialsItem.init(lastName: "Last",
                                            firstName: "First",
                                            middleName: "Middle",
                                            shippingAddress: "Sample",
                                            mobileNumber: "123456789",
                                            email: "sample@sample.com",
                                            password: "sample")
        interactor?.webService = MockWebservice()
        interactor?.validateAccountCredentials(item)
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    // MARK: CreateAccountInteractorOutput
    /// protocol implementation CreateAccountInteractorOutput
    func createAccountSuccessful(_ wasSuccessful: Bool, message: String) {
        result.isSuccess = wasSuccessful
        result.message = message
        if expectation != nil {
            if expectation?.description == "testAccountCreationFails" {
                XCTAssert(result == (false, "Email is already in use!"), "testAccountCreationFails Failed")
            }
            if expectation?.description == "testAccountCreationSuccess" {
                XCTAssert(result == (true, "Account creation Successful!"), "testAccountCreationSuccess Failed")
            }
            expectation?.fulfill()
        }
    }
}
