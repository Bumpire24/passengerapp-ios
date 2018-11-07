//
//  ProductListViewWireframe.swift
//  BetaProduct-Swift DEV
//
//  Created by Enrico Boller on 19/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

let productsListViewIdentifier = "ProductsListView"

class ProductListViewWireframe: BaseWireframe, HomeTabBarInterface {
    var productDetailWireFrame : ProductDetailWireframe?
    var productsListPresenter : ProductListPresenter?
    var productsListInteractor : ProductInteractor?
    var productsListView : ProductsListView?
    var homeView : HomeView?
    
    func configuredViewController(_ viewController: HomeView) -> UIViewController {
        self.homeView = viewController
        let productsListViewControl = productListViewController()
        productsListViewControl.tabBarItem = UITabBarItem.init(title: "PRODUCTS", image: UIImage.init(imageLiteralResourceName: "products"), tag: 1)
        productsListView = productsListViewControl
        productsListView?.eventHandler = productsListPresenter
        productsListView?.productListWireframe = self
        productsListPresenter?.productsListView = productsListViewControl
        viewController.navigationController?.pushViewController(productsListViewControl, animated: true)
        return productsListViewControl
    }
    
    func displayProductDetail(withIndex productListIndex: Int) {
        productDetailWireFrame?.presentProductDetailViewFromViewController(productsListView!, productIndex: productListIndex)
    }
    
    func productListViewController() -> ProductsListView {
        let productsListViewController = mainStoryBoard().instantiateViewController(withIdentifier: productsListViewIdentifier) as! ProductsListView
        return productsListViewController
    }
}
