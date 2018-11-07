//
//  CreateAccountPresenter.swift
//  BetaProduct-Swift
//
//  Created by User on 11/16/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

/// presenter class for Module `create account`
class CreateAccountPresenter: NSObject, CreateAccountModuleProtocol, CreateAccountInteractorOutput {
    /// variable for view
    var view : CreateAccountViewProtocol?
    /// variable for interactor
    var interactor : CreateAccountInteractorInput?
    /// variable for wireframe create account
    var wireframeCreateAccount : CreateAccountWireframe?
    /// variable for wireframe login
    
    // MARK: CreateAccountModuleProtocol
    /// implements protocol. see `CreateAccountModuleProtocol.swift`
    func validateUserCredentials(_ user: UserCredentialsItem) {
        interactor?.validateAccountCredentials(user)
    }
    
    /// implements protocol. see `CreateAccountModuleProtocol.swift`
    func proceedToLogin() {
        wireframeCreateAccount?.presentLoginView()
    }

    // MARK: CreateAccountInteractorOutput
    /// implements protocol. see `CreateAccountInteractorIO.swift`
    func createAccountSuccessful(_ wasSuccessful: Bool, message: String) {
        view?.displayMessage(message, wasAccountCreationSuccesful: wasSuccessful)
    }
}
