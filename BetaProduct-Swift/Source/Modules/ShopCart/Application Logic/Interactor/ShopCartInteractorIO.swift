//
//  ShopCartInteractorIO.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 12/18/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// Interactor Input Protocol for module `ShopCart`
protocol ShopCartInteractorInput {
    /// retrieve all cart filtered by current user in session
    func getCart()
    /**
     delete product by index from the displayed list
     - Parameters:
        - index: target index
     */
    func deleteProductByIndex(_ index: Int)
    /**
     increase product quantity by index from the displayed list
     - Parameters:
        - index: target index
     */
    func increaseQuantityOfProductByIndex(_ index: Int)
    /**
     decrease product quantity by index from the displayed list
     - Parameters:
        - index: target index
     */
    func decreaseQuantityOfProductByIndex(_ index: Int)
    /// delete all products in cart filtered by current user in session
    func deleteAllProductsInCart()
}

protocol ShopCartInteractorOuput {
    /**
     delegated method called by the interactor. Passes cart view model after request of retrieval
     - Parameters:
        - cart: view model ShopCartListDisplayItem
     */
    func gotCart(_ cart: ShopCartListDisplayItem?)
    /**
     delegated method called by the interactor. Passes a result after request for cart updation (eg. Increase Product quantity)
     - Parameters:
         - isSuccess: process was successful
         - message: message provided after updation
     */
    func cartUpdateComplete(wasSuccessful isSuccess: Bool, withMessage message: String)
}
