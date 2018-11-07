//
//  StoreCoreData.swift
//  BetaProduct-Swift
//
//  Created by User on 11/7/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

/// class implementation for StoreProtocol
class StoreCoreData: NSObject, StoreProtocol{
    /// variable for PersistentStoreCoordinator. Core Data Element.
    var persistentStoreCoordinator : NSPersistentStoreCoordinator!
    /// variable for NSManagedObjectModel. Core Data Element.
    var managedObjectModel : NSManagedObjectModel!
    /// variable for NSManagedObjectContext. Core Data Element.
    var managedObjectContext : NSManagedObjectContext!
    
    /**
     Overrides init. Setup of configuration for Core Data Elements
     */
    override init() {
        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let domains = FileManager.SearchPathDomainMask.userDomainMask
        let directory = FileManager.SearchPathDirectory.documentDirectory
        
        let applicationDocumentsDirectory = FileManager.default.urls(for: directory, in: domains).first!
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        let storeURL = applicationDocumentsDirectory.appendingPathComponent(iDooh.kDatabaseName)
        
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        managedObjectContext.undoManager = nil
        
        super.init()
    }
    
    // MARK: StoreProtocol
    /// Protocol implementation. see `StoreProtocol.swift`
    func fetchEntries(withEntityName entityName : String, withCompletionBlock block : @escaping CompletionBlock<[Any]>) {
        fetchEntries(withEntityName: entityName, withCompletionBlock: block);
    }
    
    /// Protocol implementation. see `StoreProtocol.swift`
    func fetchEntries(withEntityName entityName : String,
                      withPredicate predicate : NSPredicate?,
                      withSortDescriptors sortDescriptors : [NSSortDescriptor]?,
                      withCompletionBlock block : @escaping CompletionBlock<[Any]>) {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext)
        fetchRequest.entity = entity
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        managedObjectContext.perform {
            do {
                let queryResults = try self.managedObjectContext.fetch(fetchRequest)
                if queryResults.count == 0 {
                    block(Response.failure(iDoohError.init(domain: iDooh.kErrorDomain,
                                                        code: .Database,
                                                        description: iDooh.kGenericErrorMessage,
                                                        reason: "Found Empty Records for entity \(entityName)",
                        suggestion: "Debug function \(#function)")))
                } else {
                    block(Response.success(queryResults))
                }
            } catch let caughtError {
                let error = iDoohError.init(domain: iDooh.kErrorDomain,
                                         code: .Database,
                                         description: caughtError.localizedDescription,
                                         reason: iDooh.kGenericErrorMessage,
                                         suggestion: "Debug function \(#function)")
                error.innerError = caughtError
                DDLogError("Error  description : \(error.localizedDescription) reason : \(error.localizedFailureReason ?? "Unknown Reason") suggestion : \(error.localizedRecoverySuggestion ?? "Unknown Suggestion")")
                block(Response.failure(error))
            }
        }
    }
    
    /// Protocol implementation. see `StoreProtocol.swift`
    func newProduct() -> ManagedProduct {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Product", in: managedObjectContext)
        let newEntry = NSManagedObject.init(entity: entityDescription!, insertInto: managedObjectContext) as! ManagedProduct
        return newEntry
    }
    
    /// Protocol implementation. see `StoreProtocol.swift`
    func newUser() -> ManagedUser {
        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext)
        let newEntry = NSManagedObject.init(entity: entityDescription!, insertInto: managedObjectContext) as! ManagedUser
        return newEntry
    }
    
    /// Protocol implementation. see `StoreProtocol.swift`
    func newShopCart() -> ManagedShopCart {
        let entityDescription = NSEntityDescription.entity(forEntityName: "ShopCart", in: managedObjectContext)
        let newEntry = NSManagedObject.init(entity: entityDescription!, insertInto: managedObjectContext) as! ManagedShopCart
        return newEntry
    }
    
    func newOrder() -> ManagedOrder {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Order", in: managedObjectContext)
        let newEntry = NSManagedObject.init(entity: entityDescription!, insertInto: managedObjectContext) as! ManagedOrder
        return newEntry
    }
    
    func newOrderItem() -> ManagedOrderItem {
        let entityDescription = NSEntityDescription.entity(forEntityName: "OrderItem", in: managedObjectContext)
        let newEntry = NSManagedObject.init(entity: entityDescription!, insertInto: managedObjectContext) as! ManagedOrderItem
        return newEntry
    }
    
    /// Protocol implementation. see `StoreProtocol.swift`
    func deleteProduct(product: ManagedProduct) {
        managedObjectContext.delete(product)
    }
    
    /// Protocol implementation. see `StoreProtocol.swift`
    func deleteShopCart(cart: ManagedShopCart) {
        managedObjectContext.delete(cart)
    }
    
    /// Protocol implementation. see `StoreProtocol.swift`
    func save() {
        do {
            try managedObjectContext.save()
        } catch _ {
            
        }
    }
    
    /// Protocol implementation. see `StoreProtocol.swift`
    func saveOrRollBack() {
        do {
            try managedObjectContext.save()
        } catch _ {
            managedObjectContext.rollback()
        }
    }
    
    /// Protocol implementation. see `StoreProtocol.swift`
    func saveWithCompletionBlock(block: CompletionBlock<Bool>) {
        do {
            try managedObjectContext.save()
            block(.success(true))
        } catch let caughtError {
            let error = iDoohError.init(domain: iDooh.kErrorDomain, code: .Database, description: iDooh.kGenericErrorMessage, reason: caughtError.localizedDescription, suggestion: "Debug function \(#function)")
            error.innerError = caughtError
            print("Error : \(#function), \(error.localizedDescription)")
            block(.failure(error))
        }
    }
    
    /// Protocol implementation. see `StoreProtocol.swift`
    func saveOrRollBackWithCompletionBlock(block: CompletionBlock<Bool>) {
        do {
            try managedObjectContext.save()
            block(.success(true))
        } catch let caughtError {
            managedObjectContext.rollback()
            let error = iDoohError.init(domain: iDooh.kErrorDomain, code: .Database, description: iDooh.kGenericErrorMessage, reason: caughtError.localizedDescription, suggestion: "Debug function \(#function)")
            error.innerError = caughtError
            print("Error : \(#function), \(error.localizedDescription)")
            block(.failure(error))
        }
    }
}
