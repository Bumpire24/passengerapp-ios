//
//  ProductManager.swift
//  BetaProduct-Swift
//
//  Created by User on 11/9/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// manager class for module `Product`
class ProductManager: NSObject {
    var store : StoreProtocol?
    private var responseBlockCreate: CompletionBlock<Bool>?
    
    /**
     check if user has product in a shopcart
     - Parameters:
         - productId: target product id
         - user: user model usually from user session
         - block: callback closure
     */
    func checkIfProductIsInShopCart(byId productId: Int, withUser user: User, withCompletionBLock block: @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "status != %d AND email == %@", Status.Deleted.rawValue, user.email)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            let managedUser = response.value?.first as! ManagedUser
            if managedUser.shopcart.count > 0 {
                let managedShopCarts = managedUser.shopcart.map({$0 as! ManagedShopCart})
                if managedShopCarts.filter({$0.product.productId == productId}).count > 0 {
                    block(.success(true))
                    return
                }
            }
            block(.success(false))
        })
    }
    
    /**
     creates new products in db by batches using model Product
     - Parameters:
         - products: array of Products
         - user: user model
         - block: closure completion block
     */
    func createProduct(withProducts products: [Product], WithUser user: User, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "status != %d AND email == %@", Status.Deleted.rawValue, user.email)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate,
                            withSortDescriptors: nil,
                            withCompletionBlock: { response in
                                switch response {
                                case .success(let value):
                                    let managedUser = value?.first as! ManagedUser
                                    
                                    for product in products {
                                        let newProduct = self.store?.newProduct()
                                        newProduct?.productId = product.productId
                                        newProduct?.name = product.name
                                        newProduct?.productDescription = product.productDescription
                                        newProduct?.price = product.price
                                        newProduct?.priceDescription = product.priceDescription
                                        newProduct?.weblink = product.weblink
                                        newProduct?.productId = product.productId
                                        newProduct?.imageUrl = product.imageUrl
                                        newProduct?.imageThumbUrl = product.imageThumbUrl
                                        newProduct?.imageCompanyUrl = product.imageCompanyUrl
                                        newProduct?.createdAt = product.createdAt
                                        newProduct?.modifiedAt = product.modifiedAt
                                        newProduct?.status = product.status
                                        newProduct?.syncStatus = product.syncStatus
                                        newProduct?.addUser(user: managedUser)
                                        newProduct?.addedAt = product.addedAt
                                    }
                                    
                                    self.store?.saveWithCompletionBlock(block: { response in
                                        switch response {
                                        case .success(_):
                                            block(.success(true))
                                        case .failure(let error):
                                            block(.failure(error))
                                        }
                                    })
                                    
                                case .failure(let error):
                                    block(.failure(error))
                                }
        })
    }
    
    /**
     creates a new product in db using model Product
     - Parameters:
         - product: product model
         - block: closure completion block
     */
    func createProduct(withProduct product: Product, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        self.createProduct(withProduct: product, WithUser: nil, withCompletionBlock: block)
    }
    
    /**
     creates a new product in db using model Product
     - Parameters:
         - product: product model
         - user: user model
         - block: closure completion block
     */
    func createProduct(withProduct product: Product, WithUser user: User?, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        responseBlockCreate = block
        
        let newProduct = store?.newProduct()
        newProduct?.productId = product.productId
        newProduct?.name = product.name
        newProduct?.productDescription = product.productDescription
        newProduct?.price = product.price
        newProduct?.priceDescription = product.priceDescription
        newProduct?.weblink = product.weblink
        newProduct?.productId = product.productId
        newProduct?.imageUrl = product.imageUrl
        newProduct?.imageThumbUrl = product.imageThumbUrl
        newProduct?.imageCompanyUrl = product.imageCompanyUrl
        newProduct?.createdAt = product.createdAt
        newProduct?.modifiedAt = product.modifiedAt
        newProduct?.status = product.status
        newProduct?.syncStatus = product.syncStatus
        newProduct?.addedAt = product.addedAt
        
        if let targetUser = user {
            let predicate = NSPredicate.init(format: "status != %d AND email == %@", Status.Deleted.rawValue, targetUser.email)
            store?.fetchEntries(withEntityName: "User", withPredicate: predicate,
                                withSortDescriptors: nil,
                                withCompletionBlock: { response in
                                    switch response {
                                    case .success(let value):
                                        let managedUser = value?.first as! ManagedUser
                                        self.processProductCreation(withUser: managedUser, withProduct: newProduct)
                                    case .failure(_):
                                        self.processProductCreation(withUser: nil, withProduct: newProduct)
                                    }
            })
        } else {
            processProductCreation(withUser: nil, withProduct: newProduct)
        }
    }
    
    /**
     retrieves product in db by product id
     - Parameters:
         - id: Product id
         - block: closure completion block
     */
    func retrieveProductById(_ id: Int, withCompletionBlock block: @escaping CompletionBlock<Product>) {
        let predicate = NSPredicate.init(format: "productId == %d", id)
        store?.fetchEntries(withEntityName: "Product", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            switch response {
            case .success(let value):
                let managedProduct = value?.first as! ManagedProduct
                let product = self.productFromManagedProduct(product: managedProduct)
                block(.success(product))
            case .failure(let error): block(.failure(error))
            }
        })
    }
    
    /**
     retrieves all products in db
     - Parameters:
        - block: closure completion block
     */
    func retrieveProducts(withCompletionBlock block: @escaping CompletionBlock<[Product]>) {
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: false)
        store?.fetchEntries(withEntityName: "Product",
                            withPredicate: nil,
                            withSortDescriptors: [sortDescriptor],
                            withCompletionBlock: { response in
                                switch response {
                                case .success(let value): block(.success(self.productsFromManagedProducts(entries: value!.map { $0 as! ManagedProduct })))
                                case .failure(let error): block(.failure(error))
                                }
        })
    }
    
    /**
     retrieves all products in db
     - Parameters:
         - user: retrieves products by user filter
         - block: closure completion block
     */
    func retrieveProducts(withUser user: User, withCompletionBlock block: @escaping CompletionBlock<[Product]>) {
        let sortDescriptor = NSSortDescriptor.init(key: "addedAt", ascending: false)
        let predicate = NSPredicate.init(format: "status != %d AND email == %@", Status.Deleted.rawValue, user.email)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate,
                            withSortDescriptors: nil,
                            withCompletionBlock: { response in
                                switch response {
                                case .success(let value):
                                    let managedUser = value?.first as! ManagedUser
                                    block(.success(self.productsFromManagedProducts(entries: managedUser.products.sortedArray(using: [sortDescriptor]).map{$0 as! ManagedProduct})))
                                case .failure(let error): block(.failure(error))
                                }
        })
    }
    
    /**
     updates product in db
     - Parameters:
         - product: target product for updation
         - block: closure completion block
     */
    func updateProduct(product: Product, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        updateProduct(products: [product], withCompletionBlock: block)
    }
    
    func updateProduct(products: [Product], withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "ANY productId IN %@", products.map({$0.productId}))
        store?.fetchEntries(withEntityName: "Product",
                            withPredicate: predicate,
                            withSortDescriptors: nil,
                            withCompletionBlock: { response in
                                switch response {
                                case .success(let value):
                                    let managedProducts = value!.map({$0 as! ManagedProduct})
                                    managedProducts.forEach({ managedProduct in
                                        let product = products.first(where: {$0.productId == managedProduct.productId})!
                                        managedProduct.imageCompanyUrl = product.imageCompanyUrl
                                        managedProduct.imageUrl = product.imageUrl
                                        managedProduct.imageThumbUrl = product.imageThumbUrl
                                        managedProduct.name = product.name
                                        managedProduct.productDescription = product.productDescription
                                        managedProduct.price = product.price
                                        managedProduct.priceDescription = product.priceDescription
                                        managedProduct.productId = product.productId
                                        managedProduct.weblink = product.weblink
                                        managedProduct.modifiedAt = product.modifiedAt
                                    })
                                    self.store?.saveWithCompletionBlock(block: { response in
                                        switch response {
                                        case .success(_): block(.success(true))
                                        case .failure(let error): block(.failure(error))
                                        }
                                    })
                                case .failure(let error):
                                    block(.failure(error))
                                }
        })
    }
    
    /**
     deletes product in db
     - Parameters:
         - product: target product for deletion
         - block: closure completion block
     */
    func deleteProduct(product: Product, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "productId == %d", product.productId)
        store?.fetchEntries(withEntityName: "Product",
                            withPredicate: predicate,
                            withSortDescriptors: nil,
                            withCompletionBlock: { response in
                                switch response {
                                case .success(let value):
                                    let managedProduct = value!.first as! ManagedProduct
                                    self.store?.deleteProduct(product: managedProduct)
                                    self.store?.saveWithCompletionBlock(block: { response in
                                        switch response {
                                        case .success(_): block(.success(true))
                                        case .failure(let error): block(.failure(error))
                                        }
                                    })
                                case .failure(let error):
                                    block(.failure(error))
                                }
        })
    }
    
    /**
     converts model ManagedProduct to Product
     - Parameters:
         - product: managed product
     - Returns: converted product
     */
    private func productFromManagedProduct(product: ManagedProduct) -> Product {
        var value = Product()
        value.status = product.status
        value.syncStatus = product.syncStatus
        value.createdAt = product.createdAt
        value.modifiedAt = product.modifiedAt
        value.col1 = product.col1
        value.col2 = product.col2
        value.col3 = product.col3
        value.name = product.name
        value.weblink = product.weblink
        value.productDescription = product.productDescription
        value.price = product.price
        value.priceDescription = product.priceDescription
        value.imageUrl = product.imageUrl
        value.imageThumbUrl = product.imageThumbUrl
        value.imageCompanyUrl = product.imageCompanyUrl
        value.productId = product.productId
        value.productAddedInCart = product.shopcart.count > 0
        value.addedAt = product.addedAt
        return value
    }
    
    /**
     converts model ManagedProduct to Product by batch
     - Parameters:
        - entries: managed products
     - Returns: converted products
     */
    private func productsFromManagedProducts(entries : [ManagedProduct]) -> [Product] {
        let items = entries.map { managedProduct -> Product in
            var value = Product()
            value.status = managedProduct.status
            value.syncStatus = managedProduct.syncStatus
            value.createdAt = managedProduct.createdAt
            value.modifiedAt = managedProduct.modifiedAt
            value.col1 = managedProduct.col1
            value.col2 = managedProduct.col2
            value.col3 = managedProduct.col3
            value.name = managedProduct.name
            value.weblink = managedProduct.weblink
            value.productDescription = managedProduct.productDescription
            value.price = managedProduct.price
            value.priceDescription = managedProduct.priceDescription
            value.imageUrl = managedProduct.imageUrl
            value.imageThumbUrl = managedProduct.imageThumbUrl
            value.imageCompanyUrl = managedProduct.imageCompanyUrl
            value.productId = managedProduct.productId
            value.productAddedInCart = managedProduct.shopcart.count > 0
            value.addedAt = managedProduct.addedAt
            return value
        }
        return items
    }
    
    /**
     delegated completion block. Method reusing
     - Parameters:
         - user: managed user model
         - product: managed product model
     */
    private func processProductCreation(withUser user: ManagedUser?, withProduct product: ManagedProduct?) {
        if let userBind = user {
            product?.addUser(user: userBind)
        }
        
        store?.saveWithCompletionBlock(block: { response in
            switch response {
            case .success(_):
                responseBlockCreate!(.success(true))
            case .failure(let error):
                responseBlockCreate!(.failure(error))
            }
        })
    }
}
