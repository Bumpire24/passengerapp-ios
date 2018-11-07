//
//  SettingsPresenterTest.swift
//  BetaProduct-Swift Unit Tests
//
//  Created by User on 1/11/18.
//  Copyright © 2018 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV

class SettingsPresenterTest: XCTestCase, SettingsViewProtocol, SettingsProfileViewProtocol {
    class MockSettingsWireframe: SettingsWireframe {
        var wasCalled = false
        override func logOutUser() {
            wasCalled = true
        }
    }
    
    class MockSettingsProfileWireframe: SettingsProfileWireframe {
        var wasCalled = false
        override func presentProfileSettingsViewFromViewController(_ viewController: UIViewController) {
            wasCalled = true
        }
    }
    
    class MockSettingsEmailWireframe: SettingsChangeEmailWireframe {
        var wasCalled = false
        override func presentChangeEmailSettingsViewFromViewController(_ viewController: UIViewController) {
            wasCalled = true
        }
    }
    
    class MockSettingsInteractor: SettingsInteractor {
        override func validateAndUpdateSettings<T>(usingDisplayitem item: T) where T : SettingsDisplayItemProtocol {
            self.outputProfile?.settingsUpdationComplete(wasSuccessful: true, withMessage: "test", withNewDisplayItem: SettingsProfileDisplayItem())
            self.outputEmail?.settingsUpdationComplete(wasSuccessful: true, withMessage: "test")
        }
    }
    
    class MockSettingsInteractorFail: SettingsInteractor {
        override func validateAndUpdateSettings<T>(usingDisplayitem item: T) where T : SettingsDisplayItemProtocol {
            self.outputProfile?.settingsUpdationComplete(wasSuccessful: false, withMessage: "test", withNewDisplayItem: SettingsProfileDisplayItem())
            self.outputEmail?.settingsUpdationComplete(wasSuccessful: false, withMessage: "test")
        }
    }
    
    var result : (isSuccess : Bool, message : String) = (isSuccess : false, message : "")
    var expectation : XCTestExpectation? = nil
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        expectation = nil
        super.tearDown()
    }
    
    // MARK: tests
    func testProfileUpdateSuccess() {
        expectation = expectation(description: "testProfileUpdateSuccess")
        let interactor = MockSettingsInteractor()
        let presenter = SettingsPresenterProfile()
        
        interactor.outputProfile = presenter
        
        presenter.interactor = interactor
        presenter.profileSettingsView = self
        presenter.saveUpdates(withItem: SettingsProfileDisplayItem())
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    func testEmailUpdateSuccess() {
        expectation = expectation(description: "testEmailUpdateSuccess")
        let interactor = MockSettingsInteractor()
        let presenter = SettingsPresenterEmail()
        
        interactor.outputEmail = presenter
        
        presenter.interactor = interactor
        presenter.changeEmailView = self
        presenter.saveUpdates(withItem: SettingsEmailDisplayItem())
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    func testProfileUpdateFail() {
        expectation = expectation(description: "testProfileUpdateFail")
        let interactor = MockSettingsInteractorFail()
        let presenter = SettingsPresenterProfile()
        
        interactor.outputProfile = presenter
        
        presenter.interactor = interactor
        presenter.profileSettingsView = self
        presenter.saveUpdates(withItem: SettingsProfileDisplayItem())
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    func testEmailUpdateFail() {
        expectation = expectation(description: "testEmailUpdateFail")
        let interactor = MockSettingsInteractorFail()
        let presenter = SettingsPresenterEmail()
        
        interactor.outputEmail = presenter
        
        presenter.interactor = interactor
        presenter.changeEmailView = self
        presenter.saveUpdates(withItem: SettingsEmailDisplayItem())
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    func testLogOut() {
        class MockInteractor: SettingsInteractor {
            override func logOut() {
                outputHome?.logOutReady()
            }
        }
        
        let interactor = MockInteractor()
        let presenter = SettingsPresenterHome()
        let wireframe = MockSettingsWireframe()
        
        presenter.wireframeSettings = wireframe
        wireframe.settingsPresenter = presenter
        
        interactor.outputHome = presenter
        presenter.interactor = interactor
        
        presenter.logout()
        XCTAssertTrue(wireframe.wasCalled, "testLogOut failed")
    }
    
    func testProceedToProfile() {
        let presenter = SettingsPresenterHome()
        let wireframe = SettingsWireframe()
        wireframe.settingsView = SettingsView()
        let wireframeProfile = MockSettingsProfileWireframe()
        
        presenter.wireframeSettings = wireframe
        wireframe.settingsPresenter = presenter
        wireframe.profileSettingsWireframe = wireframeProfile
        
        presenter.proceedToProfileSettings()
        XCTAssertTrue(wireframeProfile.wasCalled, "testProceedToProfile failed")
    }
    
    func testProceedToEmail() {
        let presenter = SettingsPresenterHome()
        let wireframe = SettingsWireframe()
        wireframe.settingsView = SettingsView()
        let wireframeEmail = MockSettingsEmailWireframe()
        
        presenter.wireframeSettings = wireframe
        wireframe.settingsPresenter = presenter
        wireframe.changeEmailSettingsWireframe = wireframeEmail
        
        presenter.proceedToEmailSettings()
        XCTAssertTrue(wireframeEmail.wasCalled, "testProceedToEmail failed")
    }
    
    // MARK: SettingsViewProtocol and  SettingsProfileViewProtocol
    func displayMessage(_ message: String, isSuccessful: Bool) {
        result = (isSuccessful, message)
        if expectation != nil {
            if expectation?.description == "testProfileUpdateSuccess" {
                XCTAssert(result == (true, "test"), "testProfileUpdateSuccess failed")
            }
            if expectation?.description == "testEmailUpdateSuccess" {
                XCTAssert(result == (true, "test"), "testEmailUpdateSuccess failed")
            }
            if expectation?.description == "testProfileUpdateFail" {
                XCTAssert(result == (false, "test"), "testProfileUpdateFail failed")
            }
            if expectation?.description == "testEmailUpdateFail" {
                XCTAssert(result == (false, "test"), "testEmailUpdateFail failed")
            }
            expectation?.fulfill()
        }
    }
    
    func populateUserProfile(displayItems: SettingsProfileDisplayItem) {
        
    }
    
    func updateViewWithNewProfileImage(image: UIImage) {
        
    }
}
