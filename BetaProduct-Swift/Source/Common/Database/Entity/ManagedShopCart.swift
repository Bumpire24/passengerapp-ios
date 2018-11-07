//
//  ManagedShopCart.swift
//  BetaProduct-Swift
//
//  Created by User on 12/18/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import CoreData

/// Core Data class model for ShopCart. Inherits BaseEntity
class ManagedShopCart: BaseEntity {
    @NSManaged var quantity: Int16
    @NSManaged var product: ManagedProduct
    @NSManaged var user: ManagedUser
}
