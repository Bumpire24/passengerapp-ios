//
//  ModelProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 11/9/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// base protocol for all models. Common fields are placed here. Inherits Property Looper Protocol
protocol ModelProtocol : PropertyLooperProtocol{
    var status : Int16 { get set }
    var syncStatus : Int16 { get set }
    var createdAt : Date { get set }
    var modifiedAt : Date { get set }
    var col1 : String { get set }
    var col2 : String { get set }
    var col3 : String { get set }
}
