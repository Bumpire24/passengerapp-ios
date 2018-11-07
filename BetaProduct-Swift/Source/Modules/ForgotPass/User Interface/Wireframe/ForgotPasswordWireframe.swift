//
//  ForgotPasswordWireframe.swift
//  BetaProduct-Swift
//
//  Created by User on 2/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

let forgotPasswordViewIdentifier = "ForgotPasswordView"

class ForgotPasswordWireframe: BaseWireframe {
    var loginWireFrame : LoginWireframe?
    var forgotPasswordView : ForgotPasswordView?
    var forgotPasswordPresenter : ForgotPassPresenter?
    
    func presentForgotPasswordViewFromViewController(_ viewController: UIViewController) {
        let newViewController = forgotPasswordViewController()
        forgotPasswordView = newViewController
        forgotPasswordView?.eventHandler = forgotPasswordPresenter
        forgotPasswordPresenter?.view = newViewController
        viewController.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func forgotPasswordViewController() -> ForgotPasswordView {
        let viewcontroller = mainStoryBoard().instantiateViewController(withIdentifier: forgotPasswordViewIdentifier) as! ForgotPasswordView
        return viewcontroller
    }
    
    func presentLoginView() {
        forgotPasswordView?.navigationController?.popViewController(animated: true)
    }

}
