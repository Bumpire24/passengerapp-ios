//
//  ShopCartViewProtocol.swift
//  BetaProduct-Swift
//
//  Created by Enrico Boller on 22/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

protocol ShopCartViewProtocol {
    func displayProducts(_ cart: ShopCartListDisplayItem)
    func displayEmptyProducts()
    func obtainShopCartUpdates()
}
