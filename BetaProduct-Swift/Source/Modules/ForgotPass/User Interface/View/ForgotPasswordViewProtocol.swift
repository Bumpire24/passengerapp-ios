//
//  ForgotPasswordViewProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 2/7/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol ForgotPasswordViewProtocol {
    func displayMessage(_ message : String, wasPasswordRetrievalSuccesful wasSuccessful: Bool)
}
