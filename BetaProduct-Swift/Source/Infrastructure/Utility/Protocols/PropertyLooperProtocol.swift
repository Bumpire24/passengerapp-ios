//
//  PropertyLooperProtocol.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/22/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// protocol for Property Looper
protocol PropertyLooperProtocol {
    /**
     converts class' properties and values to a key-value dictionary
     - Returns: dictionary with property names as keys and their contents as the values
     */
    func allProperties() -> [String : Any]
}
