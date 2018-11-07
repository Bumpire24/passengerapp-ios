//
//  ShopCartModuleProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 12/18/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// module interface protocol for module `ShopCart`
protocol ShopCartModuleProtocol {
    /// retrieves all products
    func getAllProducts()
    /**
     deletes a product in the list
     - Parameters:
        - index: target index
     */
    func deleteProduct(byIndex index: Int)
    /**
     deletes a product in the list
     - Parameters:
     - index: target index
     */
    func addProductQuantity(byIndex index: Int)
    /**
     deletes a product in the list
     - Parameters:
     - index: target index
     */
    func subtractProductQuantity(byIndex index: Int)
    /// deletes all products in the list
    func clearAllProducts()
    /**
     deletes all products in the list
     - Parameters:
     - index: target index
     */
    func showProductDetailByIndex(_ index: Int)
    /**
     displays a product detail via supplied product id in the list
     - Parameters:
     - index: target index
     */
    func showProductDetailByID(_ productID: Int)
    /// proceeds to CheckOut module
    func proceedToCheckOut()
}
