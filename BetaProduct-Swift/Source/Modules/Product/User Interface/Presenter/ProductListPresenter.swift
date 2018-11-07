//
//  ProductListPresenter.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// presenter class for module `Product`
class ProductListPresenter: NSObject, ProductListModuleProtocol, ProductListInteractorOutput {
    var interactor : ProductInteractorInput?
    var productsListView : ProductsListViewProtocol?
    var productListWireframe : ProductListViewWireframe?
    
    // MARK: ProductListModuleProtocol Methods
    /// implements Protocol `ProductListModuleProtocol` see `ProductsModuleProtocol.swift`
    func getAllProducts() {
        interactor?.getProducts()
    }
    
    /// implements Protocol `ProductListModuleProtocol` see `ProductsModuleProtocol.swift`
    func removeProductItem(withIndex index: Int) {
        interactor?.deleteProductByIndex(index)
    }
    
    // MARK: ProductListInteractorOutput
    /// implements Protocol `ProductListInteractorOutput` see `ProductInteractorIO.swift`
    func gotProducts(_ products: [ProductListItem]) {
        productsListView?.displayProducts(products)
    }
    
    /// implements Protocol `ProductListInteractorOutput` see `ProductInteractorIO.swift`
    func productListDeleteComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        productsListView?.deleteProductItemFromCollection(isSuccessfullyDeleted : isSuccess, message : message)
    }
}
