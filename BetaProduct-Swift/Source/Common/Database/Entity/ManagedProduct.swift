//
//  Product.swift
//  BetaProduct-Swift
//
//  Created by User on 11/7/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import CoreData

/// Core Data class model for Product. Inherits BaseEntity
class ManagedProduct: BaseEntity {
    @NSManaged var name :               String
    @NSManaged var weblink :            String
    @NSManaged var productDescription : String
    @NSManaged var price :              Double
    @NSManaged var priceDescription :   String
    @NSManaged var imageUrl :           String
    @NSManaged var imageThumbUrl :      String
    @NSManaged var imageCompanyUrl :    String
    @NSManaged var productId :          Int
    @NSManaged var users: NSSet
    @NSManaged var shopcart: NSSet
    @NSManaged var addedAt: Date
}

/// extension for entity model Product
extension ManagedProduct {
    /**
     adds a User in users set
     - Parameters:
        - user: user managedobject
     */
    func addUser(user: NSManagedObject) {
        let currentUsers = mutableSetValue(forKey: "users")
        currentUsers.add(user)
    }
    
    /**
     remove a User in users set
     - Parameters:
        - user: user managedobject
     */
    func removeUser(user: NSManagedObject) {
        let currentUsers = mutableSetValue(forKey: "users")
        currentUsers.remove(user)
    }
    
    /**
     adds a shop cart in shopcart set
     - Parameters:
        - cart: shop cart managedobject
     */
    func addShopCart(cart: NSManagedObject) {
        let currentCart = mutableSetValue(forKey: "shopcart")
        currentCart.add(cart)
    }
    
    /**
     remove a shop cart in shopcart set
     - Parameters:
        - cart: shop cart managedobject
     */
    func removeShopCart(cart: NSManagedObject) {
        let currentCart = mutableSetValue(forKey: "shopcart")
        currentCart.remove(cart)
    }
}
