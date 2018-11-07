//
//  SettingsInteractorTest.swift
//  BetaProduct-Swift Unit Tests
//
//  Created by User on 11/29/17.
//  Copyright © 2017 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV

/// test interactor class for module `Settings`
class SettingsInteractorTest: XCTestCase, SettingsHomeInteractorOuput, SettingsProfileInteractorOutput, SettingsEmailInteractorOutput, SettingsPasswordInteractorOutput {
    /// variable for result. shared variable for class and delegate
    var result: (isSuccess : Bool, message : String, displayItem : SettingsProfileDisplayItem) = (false, "", SettingsProfileDisplayItem())
    /// variable for interactor
    var interactor : SettingsInteractor?
    /// variable for expectation
    var expectation : XCTestExpectation? = nil
    /// variable for session
    var session: MockSession? = nil

    /// mock class for session
    class MockSession: Session {
        override init() {
            super.init()
            self.user = UserSession()
            self.user?.addShipping = "sample"
            self.user?.email = "sample@gmail.com"
            self.user?.firstName = "sample"
            self.user?.lastName = "sample"
            self.user?.middleName = "sample"
            self.user?.id = 1
            self.user?.token = "token"
            self.user?.tokenExpiry = 12
            self.user?.tokenType = "sample"
        }
    }

    // use case
    // retrieve data from session for display
    // handles log out by emptying session
    // handles user updates WS and core data
    //  * Profile Image Update
    //  * Profile Update
    //  * Password Change With new password cofirmation
    //  * Email Change
    // check if updation is valid
    // provide new update and update display

    override func setUp() {
        super.setUp()
        interactor = SettingsInteractor()
        interactor?.outputHome = self
        interactor?.outputProfile = self
        interactor?.outputEmail = self
        interactor?.outputPassword = self
        session = MockSession()
    }

    override func tearDown() {
        interactor = nil
        expectation = nil
        session = nil
        super.tearDown()
    }

    /// tests if there was no change made in the item
    func testIfEntryhasnoChanges() {
        interactor?.session = session
        var item = SettingsProfileDisplayItem()
        item.firstName = "sample"
        item.middleName = "sample"
        item.lastName = "sample"
        item.addressShipping = "sample"
        interactor?.validateAndUpdateSettings(usingDisplayitem: item)
        XCTAssert(result.isSuccess == false && result.message == "No changes found for Profile!", "testIfEntryhasnoChanges failed")
    }

    /// tests if profile update fails in webservice
    func testProfileUpdateFailWebservice() {
        class MockWebservice : StoreWebClient {
            override func PATCH(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
                block(.failure(iDoohError.init(domain: "", code: .WebService, description: "No record found!", reason: "Update Failed!", suggestion: "Update Failed!")))
            }
        }

        var item = SettingsProfileDisplayItem()
        item.firstName = "samples"
        item.middleName = "sample"
        item.lastName = "sample"
        item.addressShipping = "sample"
        expectation = expectation(description: "testProfileUpdateFailWebservice")
        interactor?.webservice = MockWebservice()
        interactor?.session = session
        interactor?.validateAndUpdateSettings(usingDisplayitem: item)
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    /// tests if profile and photo upload are both successful
    func testProfileUpadteSuccessful() {
        class MockWebservice : StoreWebClient {
            override func PATCH(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
                block(.success(nil))
            }
        }

        class MockManager: SettingsManager {
            override func updateUser(user: User, withCompletionBlock block: @escaping (Response<Bool>) -> Void) {
                block(.success(nil))
            }
        }

        expectation = expectation(description: "testProfileUpadteSuccessful")
        interactor?.session = session
        interactor?.webservice = MockWebservice()
        interactor?.manager = MockManager()
        var item = SettingsProfileDisplayItem()
        item.firstName = "samples"
        item.middleName = "sample"
        item.lastName = "sample"
        item.addressShipping = "sample"
        interactor?.validateAndUpdateSettings(usingDisplayitem: item)
        self.waitForExpectations(timeout: 0.5) { _ in
        }
    }

    func testManagerFailsWhenProfileUpdateSuccessful() {
        class MockWebservice : StoreWebClient {
            override func PATCH(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
                block(.success(nil))
            }
        }

        class MockManager: SettingsManager {
            override func updateUser(user: User, withCompletionBlock block: @escaping (Response<Bool>) -> Void) {
                block(.failure(nil))
            }
        }

        expectation = expectation(description: "testManagerFailsWhenProfileUpdateSuccessful")
        interactor?.session = session
        interactor?.webservice = MockWebservice()
        interactor?.manager = MockManager()
        var item = SettingsProfileDisplayItem()
        item.firstName = "samples"
        item.middleName = "sample"
        item.lastName = "sample"
        item.addressShipping = "sample"
        interactor?.validateAndUpdateSettings(usingDisplayitem: item)
        self.waitForExpectations(timeout: 1.0) { _ in
        }
    }
    
    /// tests if Old Email matches Current Email
    func testOldEmailMatchesCurrentEmail() {
        let item = SettingsEmailDisplayItem.init(emailAddOld: "asd@gmail.com", emailAddNew: "sample@gmail.com", emailAddNewConfirm: "sample@gmail.com")
        interactor?.session = session
        interactor?.validateAndUpdateSettings(usingDisplayitem: item)
        XCTAssert(result.isSuccess == false && result.message == "Your Old Email does not match your Current Email", "testOldEmailMatchesCurrentEmail failed")
    }

    /// tests if New Email matches Confirm New Emai
    func testNewEmailMatchesConfirmEmail() {
        let item = SettingsEmailDisplayItem.init(emailAddOld: "sample@gmail.com", emailAddNew: "samples@gmail.com", emailAddNewConfirm: "sample@gmail.com")
        interactor?.session = session
        interactor?.validateAndUpdateSettings(usingDisplayitem: item)
        XCTAssert(result.isSuccess == false && result.message == "New Email and Confirm New Email does not match", "testNewEmailMatchesConfirmEmail failed")
    }

    /// tests logout
    func testLogout() {
        interactor?.session = session
        interactor?.logOut()
    }

    /// tests retrieve Session Data to be displayed
    func testGetViewModelForProfile() {
        interactor?.session = session
        interactor?.getDisplayItemForProfile()
    }

    // MARK: SettingsHomeInteractorOuput, SettingsProfileInteractorOutput, SettingsEmailInteractorOutput, SettingsPasswordInteractorOutput
    /// protocol implementation. see `SettingsInteractorIO.swift`
    func logOutReady() {
        XCTAssertNil(session?.user, "testLogout failed")
    }

    /// protocol implementation. see `SettingsInteractorIO.swift`
    func gotDisplayItem(_ item: SettingsProfileDisplayItem) {
        XCTAssert(item.firstName == "sample" &&
                  item.middleName == "sample" &&
                  item.lastName == "sample" &&
                  item.addressShipping == "sample", "testGetViewModelForProfile failed")
    }

    /// protocol implementation. see `SettingsInteractorIO.swift`
    func settingsUpdationComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        result.isSuccess = isSuccess
        result.message = message
    }

    /// protocol implementation. see `SettingsInteractorIO.swift`
    func settingsUpdationComplete(wasSuccessful isSuccess: Bool, withMessage message: String, withNewDisplayItem displayItem: SettingsProfileDisplayItem) {
        result.isSuccess = isSuccess
        result.message = message
        result.displayItem = displayItem
        if expectation != nil {
            if expectation?.description == "testProfileUpdateFailWebservice" {
                XCTAssert(result.isSuccess == false && result.message == "Profile Update Failed!", "testPhotoUploadFailAndProfileUpdateFail failed")
            }

            if expectation?.description == "testProfileUpadteSuccessful" {
                XCTAssert(result.isSuccess == true && result.message == "Profile Update successful!", "testProfileUpadteSuccessful failed")
                XCTAssert(result.displayItem.firstName == "samples", "testProfileUpadteSuccessful failed")
                XCTAssert(session?.user?.firstName == "samples", "testProfileUpadteSuccessful failed")
            }

            if expectation?.description == "testManagerFailsWhenProfileUpdateSuccessful" {
                XCTAssert(result.isSuccess == false && result.message == "Profile Update Failed!", "testManagerFailsWhenProfileUpdateSuccessful failed")
            }

            expectation?.fulfill()
        }
    }
}


