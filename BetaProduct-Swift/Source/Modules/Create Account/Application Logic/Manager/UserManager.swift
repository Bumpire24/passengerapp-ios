//
//  CreateAccountManager.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/17/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// manager class for module `CreateAccount`
class UserManager : NSObject {
    /// variable for store
    var store: StoreProtocol?
    
    /**
     creates Account with the given User Model
     - Parameters:
        - user: user input
        - block: completion closure. Follows Response class
     */
    func createAccount(withUser user : User, withCompletionBlock block : @escaping CompletionBlock<Bool>) {
        let newUser = store?.newUser()
        newUser?.email = user.email
        newUser?.firstName = user.firstName
        newUser?.lastName = user.lastName
        newUser?.middleName = user.middleName
        newUser?.addressShipping = user.addressShipping
        newUser?.id = user.id
        newUser?.syncStatus = Int16(SyncStatus.Created.rawValue)
        newUser?.createdAt = user.createdAt
        newUser?.modifiedAt = user.modifiedAt
        newUser?.profileImageURL = user.profileImageURL
        store?.saveWithCompletionBlock(block: { response in
            switch response {
            case .success(_):
                block(.success(true))
            case .failure(let error):
                block(.failure(error))
            }
        })
    }
    
    /**
     retrieves User with given inputs
     - Parameters:
     - email: email input
     - password: password input
     - block: completion closure. Follows Response class
     */
    func retrieveUser(withEmail email : String, withCompletionBlock block : @escaping CompletionBlock<User>) {
        let predicate = NSPredicate.init(format: "status != %d AND email == %@", Status.Deleted.rawValue, email)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            switch response {
            case .success(let result):
                let value = result?.first as! ManagedUser
                var user = User()
                user.createdAt = value.createdAt
                user.modifiedAt = value.modifiedAt
                user.email = value.email
                user.firstName = value.firstName
                user.lastName = value.lastName
                user.middleName = value.middleName
                user.id = value.id
                user.addressShipping = value.addressShipping
                user.syncStatus = value.syncStatus
                user.status = value.status
                user.profileImageURL = value.profileImageURL
                block(.success(user))
            case .failure(let caughtError):
                let error = iDoohError.init(domain: iDooh.kErrorDomain,
                                            code: .Database,
                                            description: (caughtError?.localizedDescription)!,
                                            reason: "No Record Found!",
                                            suggestion: (caughtError?.localizedRecoverySuggestion)!)
                error.innerBPError = caughtError
                block(Response.failure(error))
            }
        })
    }
    
    func updateUser(withUser user: User, withCompletionBlock block : @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "status != %d AND id == %d", Status.Deleted.rawValue, user.id)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            switch response {
            case .success(let value):
                let userM = value!.first as! ManagedUser
                userM.modifiedAt = user.modifiedAt
                userM.email = user.email
                userM.firstName = user.firstName
                userM.lastName = user.lastName
                userM.middleName = user.middleName
                userM.addressShipping = user.addressShipping
                userM.syncStatus = user.syncStatus
                userM.status = user.status
                userM.profileImageURL = user.profileImageURL
                self.store?.saveWithCompletionBlock(block: { response in
                    switch response {
                        case .success(_):
                            block(.success(true))
                        case .failure(let error):
                            block(.failure(error))
                    }
                    
                })
            case .failure(let error):
                block(.failure(error))
            }
        })
    }
}
