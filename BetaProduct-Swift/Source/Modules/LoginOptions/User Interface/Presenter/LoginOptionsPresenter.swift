//
//  LoginOptionsPresenter.swift
//  BetaProduct-Swift
//
//  Created by User on 11/9/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class LoginOptionsPresenter: NSObject, LoginOptionsModuleInterface {
    var window: UIWindow?
    var loginOptionsWireframe : LoginOptionsWireframe?
    var createAccountWireframe : CreateAccountWireframe?
    var view : LoginOptionsView?
    
    func login() {
        loginOptionsWireframe?.presentLoginView()
    }
    
    func createAccount() {
      loginOptionsWireframe?.presentCreateAccountView()
    }
}
