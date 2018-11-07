//
//  OrderItem.swift
//  BetaProduct-Swift
//
//  Created by User on 2/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct OrderItem : ModelProtocol {
    var orderItemId: Int = -1
    var productId: Int = -1
    var quantity: Int = 0
    var price: Double = 0.00
    var orderStatus: String = "Pending"
    var status: Int16 = Status.Active.toInt16()
    var syncStatus: Int16 = SyncStatus.Created.toInt16()
    var createdAt: Date = Date()
    var modifiedAt: Date = Date()
    var col1: String = ""
    var col2: String = ""
    var col3: String = ""
    var productName: String = ""
    var currency: String = ""
    var productImage: String = ""
}

extension OrderItem {
    var totalPrice: Double {
        get {
            return price * Double(quantity)
        }
    }
    
    init(dictionary dataDict: [String: Any]) {
        let wsConverter = WebServiceConverter.init(dataDict)
        self.orderItemId = wsConverter.intWithKey("id")
        self.productId = wsConverter.intWithKey("product_id")
        self.quantity = wsConverter.intWithKey("quantity")
        self.price = wsConverter.doubleWithKey("price")
        self.productName = wsConverter.stringWithKey("product_name")
        self.currency = wsConverter.stringWithKey("currency")
        self.productImage = wsConverter.stringWithKey("product_image")
    }
}
