//
//  ManagedOrderItem.swift
//  BetaProduct-Swift
//
//  Created by User on 2/1/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import CoreData

class ManagedOrderItem: BaseEntity {
    @NSManaged var orderItemId: Int
    @NSManaged var quantity: Int
    @NSManaged var order: ManagedOrder
    @NSManaged var orderStatus: String
    @NSManaged var price: Double
    @NSManaged var productName: String
    @NSManaged var productId: Int
    @NSManaged var currency: String
    @NSManaged var productImage: String
}
