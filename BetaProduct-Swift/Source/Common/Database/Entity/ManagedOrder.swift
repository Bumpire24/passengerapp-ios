//
//  MangedOrder.swift
//  BetaProduct-Swift
//
//  Created by User on 2/1/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import CoreData

class ManagedOrder: BaseEntity {
    @NSManaged var orderId: Int
    @NSManaged var user: ManagedUser
    @NSManaged var orderitems: NSSet
}

extension ManagedOrder {
    func addOrderItem(orderitem: NSManagedObject) {
        let currentOrderItems = mutableSetValue(forKey: "orderitems")
        currentOrderItems.add(orderitem)
    }
    
    func removeOrderItem(orderitem: NSManagedObject) {
        let currentOrderItems = mutableSetValue(forKey: "orderitems")
        currentOrderItems.remove(orderitem)
    }
}
