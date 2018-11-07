//
//  ProductInteractorTest.swift
//  BetaProduct-Swift Unit Tests
//
//  Created by User on 1/15/18.
//  Copyright © 2018 User. All rights reserved.
//

import XCTest
@testable import BetaProduct_Swift_DEV

/// test interactor class for module `Product`
class ProductInteractorTest: XCTestCase, ProductListInteractorOutput, ProductDetailInteractorOutput {
    var interactor = ProductInteractor()
    var expectation: XCTestExpectation? = nil
    var manager = MockProductManager()
    
    class MockProductManager: ProductManager {
        var failProductInCart = false
        
        override func retrieveProducts(withUser user: User, withCompletionBlock block: @escaping (Response<[Product]>) -> Void) {
            var product = Product()
            product.name = "test"
            product.imageUrl = "test"
            product.productDescription = "test"
            block(.success([product]))
        }
        
        override func checkIfProductIsInShopCart(byId productId: Int, withUser user: User, withCompletionBLock block: @escaping (Response<Bool>) -> Void) {
            block(.success(!failProductInCart))
        }
        
        override func deleteProduct(product: Product, withCompletionBlock block: @escaping (Response<Bool>) -> Void) {
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
    
    class MockWebService: StoreWebClient {
        override func GET(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
            
        }
    }
    
    class MockManagerShopCart: ShopCartManager {
        override func createShopCart(withCart cart: ShopCart, withCompletionBlock block: @escaping (Response<Bool>) -> Void) {
            block(.success(true))
        }
    }
    
    override func setUp() {
        super.setUp()
        interactor.manager = manager
        interactor.outputDetail = self
        interactor.outputList = self
        interactor.session = MockSession()
    }
    
    override func tearDown() {
        expectation = nil
        super.tearDown()
    }
    
    func testProductRetrievalAndDeletionFail() {
        expectation = expectation(description: "testProductRetrievalAndDeletionFail")
        interactor.getProducts()
        waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    func testProductRetrievalAndDeletionSuccess() {
        expectation = expectation(description: "testProductRetrievalAndDeletionSuccess")
        let managerFake = MockProductManager()
        managerFake.failProductInCart = true
        interactor.manager = managerFake
        interactor.getProducts()
        waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    func testCartUpdation() {
        expectation = expectation(description: "testCartUpdation")
        interactor.managerShopCart = MockManagerShopCart()
        interactor.addProductToCartByProductId(0)
        waitForExpectations(timeout: 0.5) { _ in
        }
    }
    
    // MARK: ProductListInteractorOutput, ProductDetailInteractorOutput
    func productListDeleteComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        if expectation != nil {
            if expectation?.description == "testProductRetrievalAndDeletionFail" {
                XCTAssert(isSuccess == false && message == "Product still exists in Cart. Delete the product from the cart first.", "testProductRetrievalAndDeletionFail failed")
            }
            if expectation?.description == "testProductRetrievalAndDeletionSuccess" {
                XCTAssert(isSuccess == true && message == "Product Deleted!", "testProductRetrievalAndDeletionFail failed")
            }
            expectation?.fulfill()
        }
    }
    
    func cartUpdateComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        if expectation != nil {
            if expectation?.description == "testCartUpdation" {
                XCTAssert(isSuccess == true && message == "Product added", "testCartUpdation failed")
            }
            expectation?.fulfill()
        }
    }
    
    func gotProducts(_ products: [ProductListItem]) {
        XCTAssert(products.first?.name == "test" && products.first?.description == "test", "testProductRetrievalAndDeletionFail failed")
        interactor.getProductDetailByIndex(0)
    }
    
    func gotProduct(_ product: ProductDetailItem?) {
        XCTAssert(product?.name == "test" && product?.imageURL == "test" && product?.description == "test", "testProductRetrievalAndDeletionFail failed")
        interactor.deleteProductByIndex(0)
    }
}
