//
//  ForgotPassInteractor.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 1/30/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class ForgotPassInteractor: ForgotPassInteractorInput {
    var webservice: StoreWebClientProtocol?
    var output: ForgotPassInteractorOutput?
    
    // MARK: ForgotPassInteractorInput
    func validateAndProcessEmail(_ email: String) {
        guard isEmailVaild(email) else {
            output?.processComplete(wasSuccessful: false, withMessage: "Email Address is Invalid.")
            return
        }
        
        webservice?.PUT(iDooh.kWSForgotPass(), parameters: ["email" : email], block: { response in
            switch response {
            case .success(_): self.output?.processComplete(wasSuccessful: true, withMessage: "An Email has been sent for your password.")
            case .failure(let error): self.output?.processComplete(wasSuccessful: false, withMessage: (error?.localizedFailureReason)!)
            }
        })
    }
    
    // MARK: Privates
    private func isEmailVaild(_ email: String) -> Bool {
        return isInputValid(input:email) && email.isValidEmail()
    }
    
    private func isInputValid(input: String) -> Bool {
        if input.count == 0 {
            return false
        }
        return true
    }
}
