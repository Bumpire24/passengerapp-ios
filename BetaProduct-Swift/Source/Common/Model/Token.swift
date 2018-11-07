//
//  Session.swift
//  BetaProduct-Swift
//
//  Created by User on 12/14/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// model for Token. Implements ModelProtocol
struct Token {
    var tokenType: String = ""
    var accessToken: String = ""
    var expiresIn: Int16 = 0
    var userId: Int16 = -1
}

/// extension for model Token
extension Token {
    /**
     parameterized init for Token
     - Parameters:
        - dataDict: dictionary parameter. For webservice parsing
     */
    init(dictionary dataDict: [String: Any]) {
        let wsConverter = WebServiceConverter.init(dataDict)
//        self.tokenType = wsConverter.stringWithKey("token_type")
        self.accessToken = wsConverter.stringWithKey("token")
//        self.expiresIn = wsConverter.int16WithKey("expires_in")
//        self.userId = wsConverter.int16WithKey("user_id")
    }
}
