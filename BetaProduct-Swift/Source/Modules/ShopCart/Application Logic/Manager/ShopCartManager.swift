//
//  ShopCartManager.swift
//  BetaProduct-Swift
//
//  Created by User on 12/18/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// manager class for module `ShopCart`
class ShopCartManager: NSObject {
    var store: StoreProtocol?
    
    /**
     insert new record of Shop Cart using given entity model ShopCart
     - Parameters:
         - cart: shopcart entity model
         - block: callback closure
     */
    func createShopCart(withCart cart: ShopCart, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "status != %d AND id == %d", Status.Deleted.rawValue, cart.userId)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            switch response {
            case .success(let value):
                let managedUser = value?.first as! ManagedUser
                let newCart = self.store?.newShopCart()
                newCart?.quantity = 1
                newCart?.user = managedUser
                
                let productPredicate = NSPredicate.init(format: "status != %d AND productId == %d", Status.Deleted.rawValue, cart.productId)
                self.store?.fetchEntries(withEntityName: "Product", withPredicate: productPredicate, withSortDescriptors: nil, withCompletionBlock: { response in
                    switch response {
                    case .success(let value):
                        let managedProduct = value?.first as! ManagedProduct
                        newCart?.product = managedProduct
                        self.store?.saveWithCompletionBlock(block: { response in
                            switch response {
                            case .success(_): block(.success(true))
                            case .failure(let error): block(.failure(error))
                            }
                        })
                    case .failure(let error): block(.failure(error))
                    }
                })
                
            case .failure(let error): block(.failure(error))
            }
        })
    }
    
    /**
     delete record of Shop Cart using given entity model ShopCart
     - Parameters:
         - cart: shopcart entity model
         - block: callback closure
     */
    func deleteShopCart(withCart cart: ShopCart, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "status != %d AND id == %d", Status.Deleted.rawValue, cart.userId)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            switch response {
            case .success(let value):
                let managedUser = value?.first as! ManagedUser
                let managedShopCart = managedUser.shopcart.map({ $0 as! ManagedShopCart }).first(where: { $0.product.productId == cart.productId })
                if let nonNilShopCart = managedShopCart {
                    self.store?.deleteShopCart(cart: nonNilShopCart)
                    self.store?.saveWithCompletionBlock(block: { response in
                        switch response {
                        case .success(_):block(.success(true))
                        case .failure(let error): block(.failure(error))
                        }
                    })
                } else {
                    let error = iDoohError.init(domain: iDooh.kErrorDomain, code: .Database, description: "Unable to find the Product", reason: iDooh.kGenericErrorMessage, suggestion: "Debug function \(#function)")
                    block(.failure(error))
                }
            case .failure(let error): block(.failure(error))
            }
        })
    }
    
    /**
     delete all record of Shop Cart filtered by the current user from user session
     - Parameters:
         - user: user entity model
         - block: callback closure
     */
    func deleteAll(withUser user: User, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "status != %d AND id == %d", Status.Deleted.rawValue, user.id)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            switch response {
            case .success(let value):
                let managedUser = value?.first as! ManagedUser
                for shopCart in managedUser.shopcart.map({ $0 as! ManagedShopCart }) {
                    self.store?.deleteShopCart(cart: shopCart)
                }
                self.store?.saveWithCompletionBlock(block: { response in
                    switch response {
                    case .success(_):block(.success(true))
                    case .failure(let error): block(.failure(error))
                    }
                })
            case .failure(let error): block(.failure(error))
            }
        })
    }
    
    /**
     retrieve all record of Shop Cart filtered by the current user from user session
     - Parameters:
         - user: user entity model
         - block: callback closure
     */
    func retrieveShopCart (withUser user: User, withCompletionBlock block: @escaping CompletionBlock<[ShopCart]>) {
        let predicate = NSPredicate.init(format: "status != %d AND id == %d", Status.Deleted.rawValue, user.id)
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: false)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate,
                            withSortDescriptors: [sortDescriptor],
                            withCompletionBlock: { response in
                                switch response {
                                case .success(let value):
                                    let managedUser = value?.first as! ManagedUser
                                    block(.success(self.ShopCartFromManagedShopCart(cart: managedUser.shopcart.map({ $0 as! ManagedShopCart }))))
                                case .failure(let error): block(.failure(error))
                                }
        })
    }
    
    /**
     update record of Shop Cart using given entity model ShopCart
     - Parameters:
         - cart: shopcart entity model
         - block: callback closure
     */
    func updateShopCart(cart: ShopCart, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "status != %d AND id == %d", Status.Deleted.rawValue, cart.userId)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            switch response {
            case .success(let value):
                let managedUser = value?.first as! ManagedUser
                let managedShopCart = managedUser.shopcart.map({ $0 as! ManagedShopCart }).first(where: { $0.product.productId == cart.productId })
                if let nonNilShopCart = managedShopCart {
                    nonNilShopCart.quantity = cart.quantity
                    self.store?.saveWithCompletionBlock(block: { response in
                        switch response {
                        case .success(_):block(.success(true))
                        case .failure(let error): block(.failure(error))
                        }
                    })
                } else {
                    let error = iDoohError.init(domain: iDooh.kErrorDomain, code: .Database, description: "Unable to find the Product", reason: iDooh.kGenericErrorMessage, suggestion: "Debug function \(#function)")
                    block(.failure(error))
                }
            case .failure(let error): block(.failure(error))
            }
        })
    }
    
    // MARK: privates
    /**
     Core Data Product converter. Converts to entity model Product
     - Parameters:
        - product: targeted model for conversion
     - Returns: converted model
     */
    private func ProductFromManagedProduct(product: ManagedProduct) -> Product {
        return Product.init(productName: product.name,
                            productDescription: product.productDescription,
                            productId: product.productId,
                            productPrice: product.price,
                            productPriceDescription: product.priceDescription,
                            productWeblink: product.weblink,
                            productImageURL: product.imageUrl,
                            productImageThumbURL: product.imageThumbUrl,
                            productImageCompanyURL: product.imageCompanyUrl)
    }
    
    /**
     Core Data ShopCart converter (array). Converts to entity model ShopCart (array)
     - Parameters:
        - cart: targeted model for conversion (array)
     - Returns: converted model (array)
     */
    private func ShopCartFromManagedShopCart(cart: [ManagedShopCart]) -> [ShopCart] {
        let items = cart.map({ managedShopCart in
            return ShopCart.init(productId: managedShopCart.product.productId, quantity: managedShopCart.quantity, userId: managedShopCart.user.id, product: ProductFromManagedProduct(product: managedShopCart.product))
        })
        return items
    }
}
