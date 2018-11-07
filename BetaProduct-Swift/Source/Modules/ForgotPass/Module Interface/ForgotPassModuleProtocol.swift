//
//  ForgotPassModuleProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 1/30/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol ForgotPassModuleProtocol {
    func validateEmailAddress(_ email: String)
    func proceedToLogin()
}
