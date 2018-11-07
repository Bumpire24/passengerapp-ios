//
//  ShopCartInteractorTest.swift
//  BetaProduct-Swift Unit Tests
//
//  Created by User on 1/18/18.
//  Copyright © 2018 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV

class ShopCartInteractorTest: XCTestCase, ShopCartInteractorOuput {
    var interactor: ShopCartInteractor? = nil
    var expectation: XCTestExpectation? = nil
    
    var testGetCartCalled = false
    var testProductDeletionCalled = false
    var testProductDeletionAllCalled = false
    var testProductQuantityUpdationSuccessCalled = false
    var testProductQuantityUpdationFailureCalled = false
    
    class MockManager: ShopCartManager {
        override func updateShopCart(cart: ShopCart, withCompletionBlock block: @escaping (Response<Bool>) -> Void) {
            block(.success(true))
        }
        
        override func retrieveShopCart(withUser user: User, withCompletionBlock block: @escaping (Response<[ShopCart]>) -> Void) {
            block(.success([ShopCart(productId: 1, quantity: 1, userId: 1)]))
        }
        
        override func deleteShopCart(withCart cart: ShopCart, withCompletionBlock block: @escaping (Response<Bool>) -> Void) {
            block(.success(true))
        }
        
        override func deleteAll(withUser user: User, withCompletionBlock block: @escaping (Response<Bool>) -> Void) {
            block(.success(true))
        }
    }
    
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
    
    override func setUp() {
        super.setUp()
        interactor = ShopCartInteractor()
        interactor?.persistedCart = [ShopCart]()
        
        interactor?.manager = MockManager()
        interactor?.session = MockSession()
        interactor?.output = self
    }
    
    override func tearDown() {
        interactor = nil
        expectation = nil
        
        testGetCartCalled = false
        testProductDeletionCalled = false
        testProductDeletionAllCalled = false
        testProductQuantityUpdationSuccessCalled = false
        testProductQuantityUpdationFailureCalled = false
        super.tearDown()
    }
    
    func testGetCart() {
        expectation = expectation(description: "testGetCart")
        interactor?.getCart()
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.testGetCartCalled, "testGetCart failed")
        }
    }
    
    func testProductDeletion() {
        expectation = expectation(description: "testGetCart")
        interactor?.persistedCart?.append(ShopCart())
        interactor?.deleteProductByIndex(0)
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.testProductDeletionCalled, "testGetCart failed")
        }
    }
    
    func testProductDeletionAll() {
        expectation = expectation(description: "testProductDeletionAll")
        interactor?.deleteAllProductsInCart()
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.testProductDeletionAllCalled, "testProductDeletionAll failed")
        }
    }
    
    func testProductQuantityUpdationSuccess() {
        expectation = expectation(description: "testProductQuantityUpdationSuccess")
        interactor?.persistedCart?.append(ShopCart())
        interactor?.increaseQuantityOfProductByIndex(0)
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.testProductQuantityUpdationSuccessCalled, "testProductQuantityUpdationSuccess failed")
        }
    }
    
    func testProductQuantityUpdationFailure() {
        expectation = expectation(description: "testProductQuantityUpdationFailure")
        interactor?.persistedCart?.append(ShopCart(productId: 1, quantity: 1, userId: 1))
        interactor?.decreaseQuantityOfProductByIndex(0)
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.testProductQuantityUpdationFailureCalled, "testProductQuantityUpdationFailure failed")
        }
    }
    
    // MARK: ShopCartInteractorOuput
    func gotCart(_ cart: ShopCartListDisplayItem?) {
        if expectation != nil {
            if cart?.items?[0].productQuantity == "1" {
                testGetCartCalled = true
            }
            expectation?.fulfill()
        }
    }
    
    func cartUpdateComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        if expectation != nil {
            
            if expectation?.description == "testGetCart" {
                if isSuccess && message == "Product Deleted!" {
                    testProductDeletionCalled = true
                }
            }
            
            if expectation?.description == "testProductDeletionAll" {
                if isSuccess && message == "Deletion Success!" {
                    testProductDeletionAllCalled = true
                }
            }
            
            if expectation?.description == "testProductQuantityUpdationSuccess" {
                if isSuccess && message == "Added more Quantity" {
                    testProductQuantityUpdationSuccessCalled = true
                }
            }
            
            if expectation?.description == "testProductQuantityUpdationFailure" {
                if !isSuccess && message == "Unable to decrease Quantity" {
                    testProductQuantityUpdationFailureCalled = true
                }
            }
            
            expectation?.fulfill()
        }
    }
}
