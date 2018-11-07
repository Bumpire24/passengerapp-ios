//
//  DatabaseTypes.swift
//  BetaProduct-Swift
//
//  Created by User on 11/7/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// enum for sync status field in models
enum SyncStatus : Int {
    case Synced = 1,
    Created,
    Updated,
    Deleted
    
    func toInt16() -> Int16 {
        return Int16(self.rawValue)
    }
}

/// enum for status field in models
enum Status : Int {
    case Active = 1,
    Inactive,
    Deleted
    
    func toInt16() -> Int16 {
        return Int16(self.rawValue)
    }
}
