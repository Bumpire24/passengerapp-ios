//
//  SettingsManager.swift
//  BetaProduct-Swift
//
//  Created by User on 11/28/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

/// manager class for module `Settings`
class SettingsManager: NSObject {
    /// variable for store
    var store: StoreProtocol?
    
    /**
     updates user record with given inputs
     - Parameters:
        - user: user data model
        - block: callback handler
     */
    func updateUser(user: User, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "status != %d AND id == %d", Status.Deleted.rawValue, user.id)
        // Check if data exists
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            switch response {
            case .success(let value):
                // value found and requires updation
                let targetUser = value?.first as! ManagedUser
                targetUser.id = user.id
                targetUser.firstName = user.firstName
                targetUser.lastName = user.lastName
                targetUser.middleName = user.middleName
                targetUser.email = user.email
                targetUser.addressShipping = user.addressShipping
                targetUser.modifiedAt = Date()
                targetUser.syncStatus = SyncStatus.Updated.toInt16()
                // save and handle
                self.store?.saveWithCompletionBlock(block: { response in
                    switch response {
                    case .success(_):
                        block(.success(true))
                    case .failure(let error):
                        block(.failure(error))
                    }
                })
            case .failure(let error):
                // shouldn't have been the case. Nevertheless will have a proper handle
                block(.failure(error))
            }
        })
    }
}
