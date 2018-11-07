//
//  PropertLooper+Default.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/22/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// extension for Property Looper that has the default implementation
extension PropertyLooperProtocol {
    /// protocol default implementation. see `PropertyLooperProtocol`
    func allProperties() -> [String : Any] {
        var result : [String : Any] = [:]
        let mirroredSelf = Mirror(reflecting: self)
        for child in mirroredSelf.children {
            guard let label = child.label else {
                continue
            }
            
            if let converted = child.value as? String {
                result[label] = converted
            } else {
                result[label] = child.value
            }
        }
        return result
    }
}
