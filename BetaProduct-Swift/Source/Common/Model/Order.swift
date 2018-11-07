//
//  CheckOut.swift
//  BetaProduct-Swift
//
//  Created by User on 1/4/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct Order : ModelProtocol {
    var orderId: Int = -1
    var userId: Int = -1
    var items: [OrderItem] = [OrderItem]()
    var addressDelivery: String = ""
    var nonce: String = ""
    var status: Int16 = Status.Active.toInt16()
    var syncStatus: Int16 = SyncStatus.Created.toInt16()
    var createdAt: Date = Date()
    var modifiedAt: Date = Date()
    var col1: String = ""
    var col2: String = ""
    var col3: String = ""
}

extension Order {
    var totalPrice: Double {
        get {
            return items.map({$0.totalPrice}).reduce(0.00, +)
        }
    }
    
    init(dictionary dataDict: [String: Any]) {
        let wsConverter = WebServiceConverter.init(dataDict)
        self.orderId = wsConverter.intWithKey("id")
        self.createdAt = wsConverter.dateWithKey("created_at")
        self.modifiedAt = wsConverter.dateWithKey("updated_at")
        self.userId = wsConverter.intWithKey("user_id")
    }
}
