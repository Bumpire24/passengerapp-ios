//
//  ForgotPassInteractorIO.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 1/30/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol ForgotPassInteractorInput {
    func validateAndProcessEmail(_ email: String)
}

protocol ForgotPassInteractorOutput {
    func processComplete(wasSuccessful isSuccess: Bool, withMessage message: String)
}
