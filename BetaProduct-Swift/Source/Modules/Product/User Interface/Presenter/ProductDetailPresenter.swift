//
//  ProductDetailPresenter.swift
//  BetaProduct-Swift DEV
//
//  Created by Enrico Boller on 18/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// presenter class for module `Product`
class ProductDetailPresenter: NSObject, ProductDetailModuleProtocol, ProductDetailInteractorOutput {
    var interactor: ProductInteractorInput?
    var productDetailView : ProductDetailViewProtocol?
    private var persistedProductId: Int?
    
    // MARK: ProductDetailModuleProtocol
    /// implements Protocol `ProductDetailModuleProtocol` see `ProductDetailModuleProtocol.swift`
    func getProductItem(atIndex index: Int) {
        interactor?.getProductDetailByIndex(index)
    }
    
    /// implements Protocol `ProductDetailModuleProtocol` see `ProductDetailModuleProtocol.swift`
    func getProductItem(byId id: Int) {
        persistedProductId = id
        interactor?.getProductDetailById(id)
    }
    
    /// implements Protocol `ProductDetailModuleProtocol` see `ProductDetailModuleProtocol.swift`
    func addToCartById(_ id: Int) {
        persistedProductId = id
        interactor?.addProductToCartByProductId(id)
    }
    
    /// implements Protocol `ProductDetailModuleProtocol` see `ProductDetailModuleProtocol.swift`
    func removeFromCartById(_ id: Int) {
        persistedProductId = id
        interactor?.removeProductFromCartByProductId(id)
    }
    
    // MARK: ProductDetailInteractorOutput
    /// implements Protocol `ProductDetailInteractorOutput` see `ProductInteractorIO.swift`
    func cartUpdateComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        if isSuccess {
            interactor?.getProductDetailById(persistedProductId!)
        } else {
            productDetailView?.displayMessage(message)
        }
    }
    
    /// implements Protocol `ProductDetailInteractorOutput` see `ProductInteractorIO.swift`
    func gotProduct(_ product: ProductDetailItem?) {
        guard product != nil else {
            productDetailView?.dismissDetailView()
            return
        }
        
        productDetailView?.displayProductInformation(productItem: product!)
    }
}
