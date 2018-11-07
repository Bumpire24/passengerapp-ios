//
//  ShopCartInteractor.swift
//  BetaProduct-Swift
//
//  Created by User on 12/18/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// Interactor class for module `ShopCart`
class ShopCartInteractor: NSObject, ShopCartInteractorInput {
    var manager: ShopCartManager?
    var output: ShopCartInteractorOuput?
    var session: Session?
    var persistedCart: [ShopCart]?
    
    // MARK: ShopCartInteractorInput
    /// implements Protocol `ShopCartInteractorInput` see `ShopCartInteractorIO.swift`
    func getCart() {
        if let user = session?.getUserSessionAsUser() {
            manager?.retrieveShopCart(withUser: user, withCompletionBlock: { response in
                switch response {
                case .success(let value):
                    self.persistedCart = value!
                    self.output?.gotCart(self.shopCartDisplayFromShopCart(value!))
                case .failure(_): self.output?.gotCart(nil)
                }
            })
        } else {
            output?.gotCart(nil)
        }
    }
    
    /// implements Protocol `ShopCartInteractorInput` see `ShopCartInteractorIO.swift`
    func deleteProductByIndex(_ index: Int) {
        if let nonNilPersistedCart = persistedCart, nonNilPersistedCart.count > 0 {
            manager?.deleteShopCart(withCart: nonNilPersistedCart[index], withCompletionBlock: { response in
                switch response {
                case .success(_): self.output?.cartUpdateComplete(wasSuccessful: true, withMessage: "Product Deleted!")
                case .failure(_): self.output?.cartUpdateComplete(wasSuccessful: false, withMessage: "Deletion Failed!")
                }
            })
        } else {
            self.output?.cartUpdateComplete(wasSuccessful: false, withMessage: "Deletion Failed!")
        }
    }
    
    /// implements Protocol `ShopCartInteractorInput` see `ShopCartInteractorIO.swift`
    func increaseQuantityOfProductByIndex(_ index: Int) {
        if let nonNilPersistedCart = persistedCart {
            var shopCart = nonNilPersistedCart[index]
            shopCart.quantity = shopCart.quantity + 1
            manager?.updateShopCart(cart: shopCart, withCompletionBlock: { response in
                switch response {
                case .success(_): self.output?.cartUpdateComplete(wasSuccessful: true, withMessage: "Added more Quantity")
                case .failure(_): self.output?.cartUpdateComplete(wasSuccessful: false, withMessage: "Unable to increase Quantity")
                }
            })
        } else {
            self.output?.cartUpdateComplete(wasSuccessful: false, withMessage: "Unable to increase Quantity")
        }
    }
    
    /// implements Protocol `ShopCartInteractorInput` see `ShopCartInteractorIO.swift`
    func decreaseQuantityOfProductByIndex(_ index: Int) {
        if let nonNilPersistedCart = persistedCart, nonNilPersistedCart.count > 0 {
            var shopCart = nonNilPersistedCart[index]
            let descreasedQuantity = shopCart.quantity - 1
            if descreasedQuantity <= 0 {
                self.output?.cartUpdateComplete(wasSuccessful: false, withMessage: "Unable to decrease Quantity")
            } else {
                shopCart.quantity = descreasedQuantity
                manager?.updateShopCart(cart: shopCart, withCompletionBlock: { response in
                    switch response {
                    case .success(_): self.output?.cartUpdateComplete(wasSuccessful: true, withMessage: "decreased Quantity")
                    case .failure(_): self.output?.cartUpdateComplete(wasSuccessful: false, withMessage: "Unable to decrease Quantity")
                    }
                })
            }
        } else {
            self.output?.cartUpdateComplete(wasSuccessful: false, withMessage: "Unable to decrease Quantity")
        }
    }
    
    /// implements Protocol `ShopCartInteractorInput` see `ShopCartInteractorIO.swift`
    func deleteAllProductsInCart() {
        if let user = session?.getUserSessionAsUser() {
            self.manager?.deleteAll(withUser: user, withCompletionBlock: { response in
                switch response {
                case .success(_): self.output?.cartUpdateComplete(wasSuccessful: true, withMessage: "Deletion Success!")
                case .failure(_): self.output?.cartUpdateComplete(wasSuccessful: false, withMessage: "Deletion Failed!")
                }
            })
        } else {
            self.output?.cartUpdateComplete(wasSuccessful: false, withMessage: "Deletion Failed!")
        }
    }
    
    // MARK: privates
    /**
     Entity model ShopCart (array) converter. Converts to view model ShopCartListDisplayItem
     - Parameters:
        - cart: targeted model for conversion
     - Returns: converted model
     */
    private func shopCartDisplayFromShopCart(_ cart: [ShopCart]) -> ShopCartListDisplayItem {
        var model = ShopCartListDisplayItem()
        model.items = [ShopCartDetailDisplayItem]()
        var totalPrice: Double = 0.00
        var currency: String?
        for shopCart in cart {
            if currency == nil {
                currency = shopCart.product.priceDescription
            }
            var detailModel = ShopCartDetailDisplayItem()
            detailModel.productId = shopCart.productId
            detailModel.productName = shopCart.product.name
            detailModel.productDescription = shopCart.product.productDescription
            detailModel.productQuantity = String(shopCart.quantity)
            detailModel.productPrice = String(Double(shopCart.quantity) * shopCart.product.price)
            detailModel.productImageURL = shopCart.product.imageThumbUrl
            totalPrice += Double(shopCart.quantity) * shopCart.product.price
            model.items?.append(detailModel)
        }
        model.totalPrice = String(format: "%@ %.2f", currency ?? "", totalPrice)
        return model
    }
}
