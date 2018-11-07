//
//  CreateAccountPresenterTest.swift
//  BetaProduct-Swift Unit Tests
//
//  Created by User on 11/27/17.
//  Copyright © 2017 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV

/// test presenter class for module `create account`
class CreateAccountPresenterTest: XCTestCase, CreateAccountViewProtocol{
    /// mock class for wireframe create account
    class MockCreateAccountWireframe : CreateAccountWireframe {
        var wasCalled = false

        override func presentLoginView() {
            wasCalled = true
        }
    }

    /// variable for result. shared variable for class and delegate
    var result : (isSuccess : Bool, message : String) = (isSuccess : false, message : "")
    /// variable for expectation
    var expectation : XCTestExpectation? = nil
    /// variable for presenter
    var presenter : CreateAccountPresenter?
    /// variable for view
    var view : CreateAccountView?
    /// variable for Wireframe
    var wireframe = MockCreateAccountWireframe()

    override func setUp() {
        super.setUp()
        presenter = CreateAccountPresenter()
        presenter?.view = self
    }

    override func tearDown() {
        presenter?.view = nil
        presenter = nil
        expectation = nil
        super.tearDown()
    }

    /// tests presenter behavior when validation fails
    func testPresenterValidationFailure() {
        class MockCreateAccountInteractor : CreateAccountInteractor {
            override func validateAccountCredentials(_ loginDisplay: UserCredentialsItem) {
                self.output?.createAccountSuccessful(false, message: "false")
            }
        }

        self.expectation = expectation(description: "testPresenterValidationFailure")
        let interactor = MockCreateAccountInteractor()
        interactor.output = presenter
        presenter?.interactor = interactor
        let stringInputSample = "sample@sample.com"
        presenter?.validateUserCredentials(UserCredentialsItem.init(lastName: stringInputSample,
                                                                    firstName: stringInputSample,
                                                                    middleName: stringInputSample,
                                                                    shippingAddress: stringInputSample,
                                                                    mobileNumber: stringInputSample,
                                                                    email: stringInputSample,
                                                                    password: stringInputSample))
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }

    /// tests presenter behavior when validation succeeds
    func testPresenterValidationSuccess() {
        class MockCreateAccountInteractor : CreateAccountInteractor {
            override func validateAccountCredentials(_ loginDisplay: UserCredentialsItem) {
                self.output?.createAccountSuccessful(true, message: "true")
            }
        }

        self.expectation = expectation(description: "testPresenterValidationSuccess")
        let interactor = MockCreateAccountInteractor()
        interactor.output = presenter
        presenter?.interactor = interactor
        presenter?.wireframeCreateAccount = wireframe
        let stringInputSample = "sample@sample.com"
        presenter?.validateUserCredentials(UserCredentialsItem.init(lastName: stringInputSample,
                                                                    firstName: stringInputSample,
                                                                    middleName: stringInputSample,
                                                                    shippingAddress: stringInputSample,
                                                                    mobileNumber: stringInputSample,
                                                                    email: stringInputSample,
                                                                    password: stringInputSample))
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }

    // MARK: CreateAccountViewProtocol
    /// Create Account View Protocol implementation
    func displayMessage(_ message: String, wasAccountCreationSuccesful wasSuccessful: Bool) {
        result.isSuccess = wasSuccessful
        result.message = message
        if expectation != nil {
            if expectation?.description == "testPresenterValidationFailure" {
                XCTAssert(self.result == (false, "false"), "testPresenterValidationSuccess failed")
            }

            if expectation?.description == "testPresenterValidationSuccess" {
                XCTAssert(self.result == (true, "true"), "testPresenterValidationSuccess failed")
                presenter?.proceedToLogin()
                XCTAssertTrue(wireframe.wasCalled, "testPresenterValidationSuccess failed")
            }
            self.expectation?.fulfill()
        }
    }
}

