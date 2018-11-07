//
//  ShopCartPresenter.swift
//  BetaProduct-Swift
//
//  Created by User on 12/21/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

/// presenter class for module `ShopCart`
class ShopCartPresenter: NSObject, ShopCartModuleProtocol, ShopCartInteractorOuput {
    var interactor : ShopCartInteractorInput?
    var shopCartView : ShopCartViewProtocol?
    var shopCartWireframe : ShopCartWireframe?
    
    //MARK: Shop Cart Module Protocol Methods
    /// implements Protocol `ShopCartModuleProtocol` see `ShopCartModuleProtocol.swift`
    func getAllProducts() {
        interactor?.getCart()
    }
    
    /// implements Protocol `ShopCartModuleProtocol` see `ShopCartModuleProtocol.swift`
    func deleteProduct(byIndex index: Int) {
        interactor?.deleteProductByIndex(index)
    }
    
    /// implements Protocol `ShopCartModuleProtocol` see `ShopCartModuleProtocol.swift`
    func proceedToCheckOut() {
        shopCartWireframe?.proceedToCheckOut()
    }
    
    /// implements Protocol `ShopCartModuleProtocol` see `ShopCartModuleProtocol.swift`
    func addProductQuantity(byIndex index: Int) {
        interactor?.increaseQuantityOfProductByIndex(index)
    }
    
    /// implements Protocol `ShopCartModuleProtocol` see `ShopCartModuleProtocol.swift`
    func subtractProductQuantity(byIndex index: Int) {
        interactor?.decreaseQuantityOfProductByIndex(index)
    }
    
    /// implements Protocol `ShopCartModuleProtocol` see `ShopCartModuleProtocol.swift`
    func clearAllProducts() {
        interactor?.deleteAllProductsInCart()
    }
    
    /// implements Protocol `ShopCartModuleProtocol` see `ShopCartModuleProtocol.swift`
    func showProductDetailByIndex(_ index: Int) {
        shopCartWireframe?.displayProductDetail(withIndex: index)
    }
    
    func showProductDetailByID(_ productID: Int) {
        shopCartWireframe?.displayProductDetail(withProductID: productID)
    }
    
    //MARK: Shop Cart Interactor Methods
    /// implements Protocol `ShopCartInteractorOutput` see `ShopCartInteractorIO.swift`
    func gotCart(_ cart: ShopCartListDisplayItem?) {
        guard cart?.items != nil else {
            shopCartView?.displayEmptyProducts()
            return
        }
        
        if(cart?.items?.count == 0) {
            shopCartView?.displayEmptyProducts()
            return
        }
        
        shopCartView?.displayProducts(cart!)
    }
    
    /// implements Protocol `ShopCartInteractorOutput` see `ShopCartInteractorIO.swift`
    func cartUpdateComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        shopCartView?.obtainShopCartUpdates()
    }
}
