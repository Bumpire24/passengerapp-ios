//
//  File.swift
//  BetaProduct-Swift
//
//  Created by User on 2/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol SyncEngineProtocol {
    func syncOrders(completionBlock block: @escaping CompletionBlock<Bool>)
    func syncUser(withUserNew userNew: User, withUserOld userOld: User, withCompletionBlock block: @escaping CompletionBlock<Bool>)
    func syncProducts(completionBlock block: @escaping CompletionBlock<Bool>)
}
