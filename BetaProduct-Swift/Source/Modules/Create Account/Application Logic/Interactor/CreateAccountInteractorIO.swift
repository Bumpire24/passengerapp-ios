//
//  CreateAccountInteractorIO.swift
//  BetaProduct-Swift
//
//  Created by User on 11/16/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// interactor input protocol for module `create account`
protocol CreateAccountInteractorInput {
    /**
     Validates Account creation with a given input. Will respond via Create Account Ouput delegate.
     - Parameters:
        - loginDisplay: given input. Display Model
     */
    func validateAccountCredentials(_ loginDisplay: UserCredentialsItem)
}

/// interactor output protocol for module `create account`
protocol CreateAccountInteractorOutput {
    /**
     callback delegation from process input.
     - Parameters:
        - wasSuccessful: input for Boolean if validation was successful
        - message: input for message from processed input
     */
    func createAccountSuccessful(_ wasSuccessful : Bool, message : String)
}