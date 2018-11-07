//
//  ShopCartWireframe.swift
//  BetaProduct-Swift
//
//  Created by Enrico Boller on 20/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

let shopCartViewIdentifier = "ShopCartView"

class ShopCartWireframe: BaseWireframe, HomeTabBarInterface {
    var shopCartView : ShopCartView?
    var shopCartPresenter : ShopCartPresenter?
    var productDetailWireframe : ProductDetailWireframe?
    var checkOutWireframe : CheckOutWireframe?
    
    func configuredViewController(_ viewController: HomeView) -> UIViewController {
        let shopCartViewControl = shopCartViewController()
        shopCartViewControl.tabBarItem = UITabBarItem.init(title: "SHOP", image: UIImage.init(imageLiteralResourceName: "shopcart"), tag: 1)
        shopCartView = shopCartViewControl
        shopCartView?.eventHandler = shopCartPresenter!
        shopCartPresenter?.shopCartView = shopCartViewControl
        viewController.navigationController?.pushViewController(shopCartViewControl, animated: true)
        return shopCartViewControl
    }
    
    func displayProductDetail(withIndex productListIndex: Int) {
        productDetailWireframe?.presentProductDetailViewFromShopCartViewController(shopCartView!, productIndex: productListIndex)
    }
    
    func displayProductDetail(withProductID productID: Int) {
        productDetailWireframe?.presentProductDetailViewFromVipresentProductDetailViewFromViewControllerewController(shopCartView!, productId: productID)
    }
    
    func proceedToCheckOut() {
        checkOutWireframe?.presentCheckOutPageViewFromViewController(shopCartView!)
    }
    
    func shopCartViewController() -> ShopCartView {
        let shopCartViewController = mainStoryBoard().instantiateViewController(withIdentifier: shopCartViewIdentifier) as! ShopCartView
        return shopCartViewController
    }
}
