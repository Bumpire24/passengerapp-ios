//
//  CreateAccountModuleProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 11/16/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// module protocol for module `create account`
protocol CreateAccountModuleProtocol {
    /**
     validates Account creation with the given inputs
     - Parameters:
     - user: input for a view model. see `UserCredentialsItem.swift`
     */
    func validateUserCredentials(_ user : UserCredentialsItem)
    
    /// navigate to Log in View
    func proceedToLogin()
}
