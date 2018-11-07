//
//  ProductListInteractorIO.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// Interactor input protocol for module `Product`
protocol ProductInteractorInput {
    /// retrieves all products
    func getProducts()
    /**
     deletes a product by index from the persisted list of retrieved products
     - Parameters:
        - index: target index in products list
     */
    func deleteProductByIndex(_ index: Int)
    /**
     retrieves product details by index based from persisted product list
     - Parameters:
        - index: target index
     */
    func getProductDetailByIndex(_ index: Int)
    /**
     retrieves product details by product id
     - Parameters:
        - id: target product id
     */
    func getProductDetailById(_ id: Int)
    /**
     adds product to shop cart
     - Parameters:
        - id: target product id
     */
    func addProductToCartByProductId(_ id: Int)
    /**
     removes product from shop cart
     - Parameters:
        - id: target product id
     */
    func removeProductFromCartByProductId(_ id: Int)
}

/// Protocol implementation for Product List Interactor (Output). Delegation
protocol ProductListInteractorOutput {
    /**
     Delegated method for product retrieval
     - Parameters:
        - products: passes products retrieved from data source
     */
    func gotProducts(_ products: [ProductListItem])
    /**
     delegated method for deleted product
     - Parameters:
         - isSuccess: bool for successful operation
         - message: message for view display
     */
    func productListDeleteComplete(wasSuccessful isSuccess: Bool, withMessage message: String)
}

protocol ProductDetailInteractorOutput {
    /**
     delegated method for product updation
     - Parameters:
         - isSuccess: bool for successful operation
         - message: message for view display
     */
    func cartUpdateComplete(wasSuccessful isSuccess: Bool, withMessage message: String)
    /**
     Delegated method for product retrieval
     - Parameters:
        - products: passes products retrieved from data source
     */
    func gotProduct(_ product: ProductDetailItem?)
}
