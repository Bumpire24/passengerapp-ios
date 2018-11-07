//
//  OrderDisplayItem.swift
//  BetaProduct-Swift
//
//  Created by User on 2/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct OrderDisplayItem {
    var totalPrice: String?
    var orderDate: String?
    var items = [OrderItemDisplayItem]()
}

struct OrderItemDisplayItem {
    var productName: String?
    var orderStatus: String?
    var orderPrice: String?
    var orderQuantity: String?
    var orderTotalPrice: String?
    var orderProductImage: String?
}
