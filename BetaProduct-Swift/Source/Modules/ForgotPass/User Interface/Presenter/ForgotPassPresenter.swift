//
//  ForgotPassPresenter.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 1/30/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class ForgotPassPresenter: ForgotPassInteractorOutput, ForgotPassModuleProtocol {
    var interactor: ForgotPassInteractorInput?
    var view : ForgotPasswordViewProtocol?
    var wireframe : ForgotPasswordWireframe?
    
    // MARK: ForgotPassModuleProtocol
    func validateEmailAddress(_ email: String) {
        interactor?.validateAndProcessEmail(email)
    }
    
    func proceedToLogin() {
        wireframe?.presentLoginView()
    }
    
    // MARK: ForgotPassInteractorOutput
    func processComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        view?.displayMessage(message, wasPasswordRetrievalSuccesful: isSuccess)
    }
}
