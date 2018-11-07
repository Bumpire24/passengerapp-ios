//
//  ShopCartDisplayItem.swift
//  BetaProduct-Swift
//
//  Created by User on 12/18/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// view model for module `ShopCart`
struct ShopCartListDisplayItem {
    var totalPrice: String?
    var items: [ShopCartDetailDisplayItem]?
}

/// view model for module `ShopCart`
struct ShopCartDetailDisplayItem {
    var productId: Int?
    var productName: String?
    var productDescription: String?
    var productPrice: String?
    var productQuantity: String?
    var productImageURL: String?
}
