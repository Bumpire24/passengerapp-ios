//
//  LogInModuleProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// module protocol for module `login`
protocol LogInModuleProtocol {
    /**
     validates User login with the given inputs
     - Parameters:
     - user: input for a view model. see `UserDisplayItem.swift`
     */
    func validateUser(_ user : UserDisplayItem)
    
    /// navigate to Home
    func proceedToHomeView()
    
    /// navigate to Create Account
    func proceedToCreateAccount()
    
    ///Navigate to Forgot Password
    func proceedToForgotPassword()
}
