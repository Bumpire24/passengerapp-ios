//
//  LogInPresenter.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

/// presenter class for Module `login`
class LogInPresenter: NSObject, LogInModuleProtocol, LogInInteractorOutput {
    /// variable for view
    var view : LoginViewProtocol?
    /// variable for interactor
    var interactor : LogInInteractorInput?
    /// variable for wireframe login
    var loginWireframe : LoginWireframe?
    
    // MARK: LogInModuleProtocol
    /// implements protocol function. see `LogInModuleProtocol.swift`
    func validateUser(_ user: UserDisplayItem) {
        interactor?.validateUserLogin(userDisplayItem: user)
    }
    
    /// implements protocol function. see `LogInModuleProtocol.swift`
    func proceedToHomeView() {
        loginWireframe?.presentHomeView()
    }
    
    /// implements protocol function. see `LogInModuleProtocol.swift`
    func proceedToCreateAccount() {
        loginWireframe?.presentCreateAccount()
    }
    
    func proceedToForgotPassword() {
        loginWireframe?.presentForgotPassword()
    }
    
    // MARK: LogInInteractorOutput
    /// implements protocol function. see `LogInInteractorIO.swift`
    func userLoginValidationComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        view?.displayMessage(message, isSuccessful: isSuccess)
    }
}
