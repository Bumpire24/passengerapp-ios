//
//  StoreProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 11/7/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// Store Protocol. Being used by the app across all modules as the database abstract
protocol StoreProtocol {
    /**
     Get Records from Data Source
     - Parameters:
         - entityName: Table Name.
         - block: Callback Closure. see `CompletionBlockTypes.swift`
     */
    func fetchEntries(withEntityName entityName : String, withCompletionBlock block : @escaping CompletionBlock<[Any]>)
    
    /**
     Get Records from Data Source
     - Parameters:
         - entityName: Table Name.
         - predicate: SQL Query.
         - sortDescriptors: Record Sorting.
         - block: Callback Closure. see CompletionBlockTypes.swift
     */
    func fetchEntries(withEntityName entityName : String,
                        withPredicate predicate : NSPredicate?,
            withSortDescriptors sortDescriptors : [NSSortDescriptor]?,
            withCompletionBlock block : @escaping CompletionBlock<[Any]>)
    
    /// Insert to Table Product
    func newProduct() -> ManagedProduct
    
    /// Insert to Table ShopCart
    func newShopCart() -> ManagedShopCart
    
    /// Insert to Table User
    func newUser() -> ManagedUser
    
    func newOrder() -> ManagedOrder
    
    func newOrderItem() -> ManagedOrderItem
    
    /**
     Delete Record from Table Product
     - Parameters:
        - product: record type ManagedProduct. see `ManagedProduct.swift`
     */
    func deleteProduct(product : ManagedProduct)
    
    /**
     Delete Record from Table ShopCart
     - Parameters:
        - cart: record type ManagedShopCart. see `ManagedShopCart.swift`
     */
    func deleteShopCart(cart : ManagedShopCart)
    
    /// Save transactions from stack.
    func save()
    
    /// Save transactions from stack. If it fails do a rollback.
    func saveOrRollBack()
    
    /**
     Save transactions from stack.
     - Parameters:
        - block: Callback Closure. see CompletionBlockTypes.swift
     */
    func saveWithCompletionBlock(block : CompletionBlock<Bool>)
    
    /**
     Save transactions from stack. If it fails do a rollback.
     - Parameters:
        - block: Callback Closure. see CompletionBlockTypes.swift
     */
    func saveOrRollBackWithCompletionBlock(block : CompletionBlock<Bool>)
}
