//
//  ShopCartPresenterTest.swift
//  BetaProduct-Swift Unit Tests
//
//  Created by User on 1/18/18.
//  Copyright © 2018 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV

class ShopCartPresenterTest: XCTestCase, ShopCartViewProtocol {
    var expectation: XCTestExpectation? = nil
    var presenter: ShopCartPresenter? = nil
    var interactor: MockInteractor? = nil
    var wireframe: MockWireframe? = nil
    
    var displayProductsCalled = false
    var displayEmptyProductsCalled = false
    var obtainShopCartUpdatesCalled = false
    
    class MockInteractor: ShopCartInteractor {
        var addItemsToCart = false
        
        override func getCart() {
            var cart = ShopCartListDisplayItem()
            if addItemsToCart {
                cart.items = [ShopCartDetailDisplayItem]()
                cart.items?.append(ShopCartDetailDisplayItem())
            }
             output?.gotCart(ShopCartListDisplayItem())
        }
        
        override func deleteProductByIndex(_ index: Int) {
            output?.cartUpdateComplete(wasSuccessful: true, withMessage: "")
        }
        
        override func deleteAllProductsInCart() {
            output?.cartUpdateComplete(wasSuccessful: true, withMessage: "")
        }
        
        override func increaseQuantityOfProductByIndex(_ index: Int) {
            output?.cartUpdateComplete(wasSuccessful: true, withMessage: "")
        }
        
        override func decreaseQuantityOfProductByIndex(_ index: Int) {
            output?.cartUpdateComplete(wasSuccessful: true, withMessage: "")
        }
    }
    
    class MockWireframe: ShopCartWireframe {
        var productDetailCalled = false
        var checkoutCalled = false
        
        override func proceedToCheckOut() {
            checkoutCalled = true
        }
        
        override func displayProductDetail(withIndex productListIndex: Int) {
            productDetailCalled = true
        }
    }
    
    override func setUp() {
        super.setUp()
        presenter = ShopCartPresenter()
        interactor = MockInteractor()
        wireframe = MockWireframe()
        interactor?.output = presenter
        presenter?.interactor = interactor
        presenter?.shopCartWireframe = wireframe
        presenter?.shopCartView = self
    }
    
    override func tearDown() {
        presenter = nil
        expectation = nil
        interactor = nil
        displayProductsCalled = false
        displayEmptyProductsCalled = false
        obtainShopCartUpdatesCalled = false
        super.tearDown()
    }
    
    func testGetAllProductsEmpty() {
        expectation = expectation(description: "testGetAllProductsEmpty")
        presenter?.getAllProducts()
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.displayEmptyProductsCalled, "testGetAllProductsEmpty failed")
        }
    }
    
    func testGetAllProducts() {
        expectation = expectation(description: "testGetAllProducts")
        interactor?.addItemsToCart = true
        presenter?.getAllProducts()
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.displayProductsCalled, "testGetAllProducts failed")
        }
    }
    
    func testDeleteProduct() {
        expectation = expectation(description: "testDeleteProduct")
        interactor?.addItemsToCart = true
        presenter?.deleteProduct(byIndex: 0)
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.obtainShopCartUpdatesCalled, "testDeleteProduct failed")
        }
    }
    
    func testDeleteAllProduct() {
        expectation = expectation(description: "testDeleteAllProduct")
        interactor?.addItemsToCart = true
        presenter?.clearAllProducts()
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.obtainShopCartUpdatesCalled, "testDeleteAllProduct failed")
        }
    }
    
    func testIncreaseProductQuantity() {
        expectation = expectation(description: "testIncreaseProductQuantity")
        interactor?.addItemsToCart = true
        presenter?.addProductQuantity(byIndex: 0)
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.obtainShopCartUpdatesCalled, "testIncreaseProductQuantity failed")
        }
    }
    
    func testDecreaseProductQuantity() {
        expectation = expectation(description: "testDecreaseProductQuantity")
        interactor?.addItemsToCart = true
        presenter?.subtractProductQuantity(byIndex: 0)
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.obtainShopCartUpdatesCalled, "testDecreaseProductQuantity failed")
        }
    }
    
    func testProductDetailDisplay() {
        presenter?.showProductDetailByIndex(0)
        XCTAssertTrue(wireframe!.productDetailCalled, "testProductDetailDisplay failed")
    }
    
    func testCheckOutCall() {
        presenter?.proceedToCheckOut()
        XCTAssertTrue(wireframe!.checkoutCalled, "testCheckOutCall failed")
    }
    
    // MARK: ShopCartViewProtocol
    func displayProducts(_ cart: ShopCartListDisplayItem) {
    }
    
    func displayEmptyProducts() {
        if expectation != nil {
            if expectation?.description == "testGetAllProductsEmpty" {
                displayEmptyProductsCalled = true
            }
            
            if expectation?.description == "testGetAllProducts" {
                displayProductsCalled = true
            }
            expectation?.fulfill()
        }
    }
    
    func obtainShopCartUpdates() {
        if expectation != nil {
            obtainShopCartUpdatesCalled = true
            expectation?.fulfill()
        }
    }
}
