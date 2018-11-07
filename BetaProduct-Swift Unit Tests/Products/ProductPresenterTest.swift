//
//  ProductPresenterTest.swift
//  BetaProduct-Swift Unit Tests
//
//  Created by User on 1/17/18.
//  Copyright © 2018 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV

class ProductPresenterTest: XCTestCase, ProductDetailViewProtocol, ProductsListViewProtocol {
    var presenterList: ProductListPresenter? = nil
    var presenterDetail: ProductDetailPresenter? = nil
    var expectation: XCTestExpectation? = nil
    var interactor: ProductInteractor? = nil
    
    var listViewCalled = false
    var listViewDeleteCalledCorrectly = false
    var cartUpdationTrueCalled = false
    var cartUpdationFalseCalled = false
    var testGetProductCalled = false
    
    class MockInteractor: ProductInteractor {
        var dummyItem = ProductDetailItem(id: 0, name: "",
                                      description: "", price: "",
                                      priceDescription: "", imageURL: "",
                                      imageThumbURL: "", imageCompanyURL: "",
                                      companyWeblink: "", isAddedToShopCart: false)
        
        override func getProducts() {
            outputList?.gotProducts([ProductListItem(name: "", description: "", imageURL: "")])
        }
        
        override func deleteProductByIndex(_ index: Int) {
            outputList?.productListDeleteComplete(wasSuccessful: true, withMessage: "test")
        }
        
        override func getProductDetailById(_ id: Int) {
            outputDetail?.gotProduct(dummyItem)
        }
        
        override func getProductDetailByIndex(_ index: Int) {
            outputDetail?.gotProduct(dummyItem)
        }
        
        override func addProductToCartByProductId(_ id: Int) {
            outputDetail?.cartUpdateComplete(wasSuccessful: true, withMessage: "test")
        }
        
        override func removeProductFromCartByProductId(_ id: Int) {
            outputDetail?.cartUpdateComplete(wasSuccessful: false, withMessage: "test")
        }
    }
    
    override func setUp() {
        super.setUp()
        interactor = MockInteractor()
        presenterList = ProductListPresenter()
        presenterDetail = ProductDetailPresenter()
        interactor?.outputList = presenterList
        interactor?.outputDetail = presenterDetail
        presenterList?.interactor = interactor
        presenterList?.productsListView = self
        presenterDetail?.interactor = interactor
        presenterDetail?.productDetailView = self
    }
    
    override func tearDown() {
        expectation = nil
        interactor = nil
        presenterList = nil
        presenterDetail = nil
        listViewCalled = false
        listViewDeleteCalledCorrectly = false
        cartUpdationTrueCalled = false
        cartUpdationFalseCalled = false
        testGetProductCalled = false
        super.tearDown()
    }
    
    func testGetProducts() {
        expectation = expectation(description: "testGetProducts")
        presenterList?.getAllProducts()
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.listViewCalled, "testGetProducts failed")
        }
    }
    
    func testRemoveProductItem() {
        expectation = expectation(description: "testRemoveProductItem")
        presenterList?.removeProductItem(withIndex: 0)
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.listViewDeleteCalledCorrectly, "testRemoveProductItem failed")
        }
    }
    
    func testUpdateCartSuccess() {
        expectation = expectation(description: "testUpdateCartSuccess")
        presenterDetail?.addToCartById(0)
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.cartUpdationTrueCalled, "testUpdateCartSuccess failed")
        }
    }
    
    func testUpdateCartFailed() {
        expectation = expectation(description: "testUpdateCartFailed")
        presenterDetail?.removeFromCartById(0)
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.cartUpdationFalseCalled, "testUpdateCartFailed failed")
        }
    }
    
    func testGetProduct() {
        expectation = expectation(description: "testGetProduct")
        presenterDetail?.getProductItem(atIndex: 0)
        self.waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(self.testGetProductCalled, "testGetProduct failed")
        }
    }
    
    // MARK: ProductDetailViewProtocol, ProductsListViewProtocol
    func fetchProductDetail(ofItemIndexAt itemIndex: Int) {
        
    }
    
    func fetchProductDetail(ofProductById id: Int) {
        
    }
    
    func dismissDetailView() {
        
    }
    
    func displayProductInformation(productItem: ProductDetailItem) {
        if expectation != nil {
            if expectation?.description == "testUpdateCartSuccess" {
                cartUpdationTrueCalled = true
            }
            if expectation?.description == "testGetProduct" {
                testGetProductCalled = true
            }
            expectation?.fulfill()
        }
    }
    
    func displayMessage(_ message: String) {
        if expectation != nil {
            cartUpdationFalseCalled = true
            expectation?.fulfill()
        }
    }
    
    func displayProducts(_ products: [ProductListItem]) {
        if expectation != nil {
            listViewCalled = true
            expectation?.fulfill()
        }
    }
    
    func deleteProductItemFromCollection(isSuccessfullyDeleted: Bool, message: String) {
        if expectation != nil {
            listViewDeleteCalledCorrectly = isSuccessfullyDeleted && message == "test"
            expectation?.fulfill()
        }
    }
}
