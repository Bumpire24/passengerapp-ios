//
//  ProductListInteractor.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// Interactor Class for Module `Product`
class ProductInteractor: NSObject, ProductInteractorInput {
    var outputList: ProductListInteractorOutput?
    var outputDetail: ProductDetailInteractorOutput?
    var manager: ProductManager?
    var managerShopCart: ShopCartManager?
    var session: Session?
    var webservice: StoreWebClientProtocol?
    var syncEngine: SyncEngineProtocol?
    private var persistedProducts: [Product]?
    
    // retrieve all products in db filtered by user
    // persist retrieved Products
    // convert products to displayable
    // call output to display products
    // deletes product by index
    // adds new product
    // adds products to shopcart
    // removes products from shopcart
    
    // MARK: ProductListInteractorInput
    /// implements Protocol `ProductInteractorInput` see `ProductInteractorIO.swift`
    func getProducts() {
        syncEngine?.syncProducts(completionBlock: { _ in
            self.getProductToPersistAndToShowAsOutput()
        })
//        if let nonNilSession = session {
//            if (nonNilSession.hasAlreadySynced()) {
//                getProductToPersistAndToShowAsOutput()
//            } else {
//                webservice?.GET(iDooh.kWSProducts(), parameters: nil, block: { response in
//                    switch response {
//                    case .success(let value):
//                        let products = value?.map({Product.init(dictionary: $0 as! [String: Any])})
//                        if let nonNilProducts = products {
//                            self.manager?.createProduct(withProducts: nonNilProducts,
//                                                        WithUser: nonNilSession.getUserSessionAsUser(),
//                                                        withCompletionBlock: { response in
//                                                            switch response {
//                                                            case .success(_):
//                                                                nonNilSession.markSyncCompleted()
//                                                                self.getProductToPersistAndToShowAsOutput()
//                                                            case .failure(_):
//                                                                self.outputList?.gotProducts([])
//                                                            }
//                            })
//                        } else {
//                            self.outputList?.gotProducts([])
//                        }
//                    case .failure(_):
//                        self.outputList?.gotProducts([])
//                    }
//                })
//            }
//        } else {
//            outputList?.gotProducts([])
//        }
    }
    
    /// implements Protocol `ProductInteractorInput` see `ProductInteractorIO.swift`
    func deleteProductByIndex(_ index: Int) {
        guard let nonNilSession = session else {
            outputList?.productListDeleteComplete(wasSuccessful: false, withMessage: "Deletion Failed!")
            return
        }
        
        guard let persistedProducts = persistedProducts, persistedProducts.count > 0 else {
            outputList?.productListDeleteComplete(wasSuccessful: false, withMessage: "Deletion Failed!")
            return
        }
        
        let productTobeDeleted = persistedProducts[index]
        // check if product exists in shopcart
        manager?.checkIfProductIsInShopCart(byId: productTobeDeleted.productId, withUser: nonNilSession.getUserSessionAsUser(), withCompletionBLock: { response in
            if response.value! {
                self.outputList?.productListDeleteComplete(wasSuccessful: false, withMessage: "Product still exists in Cart. Delete the product from the cart first.")
            } else {
                self.manager?.deleteProduct(product: productTobeDeleted, withCompletionBlock: { response in
                    switch response {
                    case .success(_): self.outputList?.productListDeleteComplete(wasSuccessful: true, withMessage: "Product Deleted!")
                    case .failure(_): self.outputList?.productListDeleteComplete(wasSuccessful: false, withMessage: "Deletion Failed!")
                    }
                })
            }
        })
    }
    
    /// implements Protocol `ProductInteractorInput` see `ProductInteractorIO.swift`
    func getProductDetailByIndex(_ index: Int) {
        if let nonNilPersistedProducts = persistedProducts, nonNilPersistedProducts.count > 0 {
            let productToBeDisplayed = nonNilPersistedProducts[index]
            outputDetail?.gotProduct(ProductDetailItem(id: productToBeDisplayed.productId,
                                                       name: productToBeDisplayed.name,
                                                       description: productToBeDisplayed.productDescription,
                                                       price: productToBeDisplayed.priceDescription + " " + String(describing: productToBeDisplayed.price),
                                                       priceDescription: productToBeDisplayed.priceDescription,
                                                       imageURL: productToBeDisplayed.imageUrl,
                                                       imageThumbURL: productToBeDisplayed.imageThumbUrl,
                                                       imageCompanyURL: productToBeDisplayed.imageCompanyUrl,
                                                       companyWeblink: productToBeDisplayed.weblink,
                                                       isAddedToShopCart: productToBeDisplayed.productAddedInCart))
        } else {
            outputDetail?.gotProduct(nil)
        }
    }
    
    /// implements Protocol `ProductInteractorInput` see `ProductInteractorIO.swift`
    func getProductDetailById(_ id: Int) {
        manager?.retrieveProductById(id, withCompletionBlock: { response in
            switch response {
            case .success(let value):
                let productToBeDisplayed = value!
                self.outputDetail?.gotProduct(ProductDetailItem(id: productToBeDisplayed.productId,
                                                                name: productToBeDisplayed.name,
                                                                description: productToBeDisplayed.productDescription,
                                                                price: productToBeDisplayed.priceDescription + " " + String(describing: productToBeDisplayed.price),
                                                                priceDescription: productToBeDisplayed.priceDescription,
                                                                imageURL: productToBeDisplayed.imageUrl,
                                                                imageThumbURL: productToBeDisplayed.imageThumbUrl,
                                                                imageCompanyURL: productToBeDisplayed.imageCompanyUrl,
                                                                companyWeblink: productToBeDisplayed.weblink,
                                                                isAddedToShopCart: productToBeDisplayed.productAddedInCart))
            case .failure(_): self.outputDetail?.gotProduct(nil)
            }
        })
    }
    
    /// implements Protocol `ProductInteractorInput` see `ProductInteractorIO.swift`
    func addProductToCartByProductId(_ id: Int) {
        if let user = session?.getUserSessionAsUser() {
            var shopCart = ShopCart()
            shopCart.userId = user.id
            shopCart.productId = id
            managerShopCart?.createShopCart(withCart: shopCart, withCompletionBlock: { response in
                switch response {
                case .success(_):
                    self.updatePersistedProductToAddInCart(true, self.persistedProducts?.index(where: {$0.productId == id}))
                    self.outputDetail?.cartUpdateComplete(wasSuccessful: true, withMessage: "Product added")
                case .failure(_): self.outputDetail?.cartUpdateComplete(wasSuccessful: false, withMessage: "Unable to add Product")
                }
            })
        } else {
            outputDetail?.cartUpdateComplete(wasSuccessful: false, withMessage: "Unable to add Product")
        }
    }
    
    /// implements Protocol `ProductInteractorInput` see `ProductInteractorIO.swift`
    func removeProductFromCartByProductId(_ id: Int) {
        if let user = session?.getUserSessionAsUser() {
            var shopCart = ShopCart()
            shopCart.userId = user.id
            shopCart.productId = id
            managerShopCart?.deleteShopCart(withCart: shopCart, withCompletionBlock: { response in
                switch response {
                case .success(_):
                    self.updatePersistedProductToAddInCart(false, self.persistedProducts?.index(where: {$0.productId == id}))
                    self.outputDetail?.cartUpdateComplete(wasSuccessful: true, withMessage: "Product removed")
                case .failure(_): self.outputDetail?.cartUpdateComplete(wasSuccessful: false, withMessage: "Unable to remove Product")
                }
            })
        } else {
            outputDetail?.cartUpdateComplete(wasSuccessful: false, withMessage: "Unable to remove Product")
        }
    }
    
    // MARK: Privates
    /// helper method. persists retrieved products from db and calls presenter
    private func getProductToPersistAndToShowAsOutput() {
        manager?.retrieveProducts(withUser: session!.getUserSessionAsUser(), withCompletionBlock: { response in
            switch response {
            case .success(let value):
                self.persistedProducts = value
                self.outputList?.gotProducts(self.productDisplaysFromProducts(value!))
            case .failure(_): self.outputList?.gotProducts([])
            }
        })
    }
    
    /**
     converts product to view model products by batch
     - Parameters:
        - products: target products
     - Returns: product view models
     */
    private func productDisplaysFromProducts(_ products: [Product]) -> [ProductListItem] {
        let items = products.map { product in
            return ProductListItem(name: product.name,
                                   description: product.productDescription,
                                   imageURL: product.imageThumbUrl)
        }
        return items
    }
    
    /**
     updates persisted data when added/removed in cart
     - Parameters:
        - value: value for productAddedInCart
        - index: target index from the displayed list
     */
    private func updatePersistedProductToAddInCart(_ value: Bool, _ index: Int?) {
        if let index = index {
            let oldProduct = self.persistedProducts![index]
            var newProduct = Product()
            newProduct.status = oldProduct.status
            newProduct.syncStatus = oldProduct.syncStatus
            newProduct.createdAt = oldProduct.createdAt
            newProduct.modifiedAt = oldProduct.modifiedAt
            newProduct.col1 = oldProduct.col1
            newProduct.col2 = oldProduct.col2
            newProduct.col3 = oldProduct.col3
            newProduct.name = oldProduct.name
            newProduct.weblink = oldProduct.weblink
            newProduct.productDescription = oldProduct.productDescription
            newProduct.price = oldProduct.price
            newProduct.priceDescription = oldProduct.priceDescription
            newProduct.imageUrl = oldProduct.imageUrl
            newProduct.imageThumbUrl = oldProduct.imageThumbUrl
            newProduct.imageCompanyUrl = oldProduct.imageCompanyUrl
            newProduct.productId = oldProduct.productId
            newProduct.productAddedInCart = value
            self.persistedProducts![index] = newProduct
        }
    }
}
