//
//  LoginPresenterTest.swift
//  BetaProduct-SwiftTests
//
//  Created by User on 11/23/17.
//  Copyright © 2017 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV

/// test presenter class for module 'login'
class LoginPresenterTest: XCTestCase, LoginViewProtocol {
    class MockLoginWireframe : LoginWireframe {
        var wasCalled = false
        
        override func presentHomeView() {
            wasCalled = true
        }
    }
    
    /// variable for result. shared variable for class and delegate
    var result : (isSuccess : Bool, message : String) = (isSuccess : false, message : "")
    /// variable for expectation
    var expectation : XCTestExpectation? = nil
    /// variable for presenter
    var presenter : LogInPresenter?
    /// variable for view
    var view : LoginView?
    /// variable for Wireframe
    var wireframe = MockLoginWireframe()
    
    override func setUp() {
        super.setUp()
        presenter = LogInPresenter()
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
        class MockLoginInteractor : LogInInteractor {
            override func validateUserLogin(userDisplayItem user: UserDisplayItem) {
                self.output?.userLoginValidationComplete(wasSuccessful: false, withMessage: "false")
            }
        }
        
        self.expectation = expectation(description: "testPresenterValidationFailure")
        let interactor = MockLoginInteractor()
        interactor.output = presenter
        presenter?.interactor = interactor
        presenter?.validateUser(UserDisplayItem(email: "", password: ""))
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    /// tests presenter behavior when validation succeeds
    func testPresenterValidationSuccess() {
        class MockLoginInteractor : LogInInteractor {
            override func validateUserLogin(userDisplayItem user: UserDisplayItem) {
                self.output?.userLoginValidationComplete(wasSuccessful: true, withMessage: "true")
            }
        }
        
        self.expectation = expectation(description: "testPresenterValidationSuccess")
        let interactor = MockLoginInteractor()
        interactor.output = presenter
        presenter?.interactor = interactor
        presenter?.loginWireframe = wireframe
        presenter?.validateUser(UserDisplayItem(email: "", password: ""))
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    // MARK: LoginViewProtocol
    /// Login View Protocol implementation
    func displayMessage(_ message: String, isSuccessful: Bool) {
        result.isSuccess = isSuccessful
        result.message = message
        if expectation != nil {
            if expectation?.description == "testPresenterValidationSuccess" {
                XCTAssert(self.result == (true, "true"), "testPresenterValidationSuccess failed")
                presenter?.proceedToHomeView()
                XCTAssertTrue(wireframe.wasCalled, "testPresenterValidationSuccess failed")
            }
            
            if expectation?.description == "testPresenterValidationFailure" {
                XCTAssert(self.result == (false, "false"), "testPresenterValidationSuccess failed")
            }
            self.expectation?.fulfill()
        }
    }
}
