//
//  LogInInteractorIO.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// interactor input protocol for module `login`
protocol LogInInteractorInput {
    /**
     Validates User Login with a given input. Will respond via Login Ouput delegate.
     - Parameters:
        - user: given input. Display Model
     */
    func validateUserLogin(userDisplayItem user: UserDisplayItem)
}

/// interactor output protocol for module `login`
protocol LogInInteractorOutput {
    /**
     callback delegation from process input.
     - Parameters:
        - isSuccess: input for Boolean if validation was successful
        - message: input for message from processed input
     */
    func userLoginValidationComplete(wasSuccessful isSuccess: Bool, withMessage message: String)
}
