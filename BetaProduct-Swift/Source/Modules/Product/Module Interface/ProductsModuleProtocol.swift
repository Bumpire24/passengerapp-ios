//
//  ProductsModuleProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 12/14/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// module interface for Module `Product`
protocol ProductListModuleProtocol {
    /// retrieves all Products by List
    func getAllProducts()
    /**
     removes product by index
     - Parameters:
        - index: target index
     */
    func removeProductItem(withIndex index: Int)
}

/// module interface for Module `Product`
protocol ProductDetailModuleProtocol {
    /**
     retrieves product details by index
     - Parameters:
        - index: target index
     */
    func getProductItem(atIndex index: Int)
    /**
     retrieves product details by product id
     - Parameters:
        - id: target product id
     */
    func getProductItem(byId id: Int)
    /**
     adds the product to shopcart
     - Parameters:
        - id: target product id
     */
    func addToCartById(_ id: Int)
    /**
     removes the product from shopcart
     - Parameters:
        - id: target product id
     */
    func removeFromCartById(_ id: Int)
}
