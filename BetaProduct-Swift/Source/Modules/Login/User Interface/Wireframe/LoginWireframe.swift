//
//  LoginWireframe.swift
//  BetaProduct-Swift
//
//  Created by User on 11/9/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

let loginViewIdentifier = "LoginView"

class LoginWireframe: BaseWireframe {
    var loginView : LoginView?
    var rootWireFrame : RootWireframe?
    var loginPresenter : LogInPresenter?
    var homeWireFrame : HomeWireframe?
    var createAccountWireframe : CreateAccountWireframe?
    var forgotPasswordWireframe : ForgotPasswordWireframe?
    var window: UIWindow?
    let transition = BetaProductTransitionAnimator()
    
    func presentLoginViewInterfaceFromWindow(Window window : UIWindow) {
        self.window = window
        let viewcontroller = mainStoryBoard().instantiateViewController(withIdentifier: loginViewIdentifier) as! LoginView
        viewcontroller.eventHandler = loginPresenter
        loginView = viewcontroller
        loginView?.transitioningDelegate = self
        loginPresenter?.view = viewcontroller
        rootWireFrame?.showRootViewController(rootViewController: viewcontroller, inWindow: window)
    }
    
    func presentLoginViewFromViewController(_ viewController: UIViewController) {
        let newViewController = loginViewController()
        loginView = newViewController
        loginView?.eventHandler = loginPresenter
        loginPresenter?.view = newViewController
        viewController.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func presentHomeView() {
        homeWireFrame?.presentHomeViewFromViewController(loginView!)
    }
    
    func presentCreateAccount() {
        createAccountWireframe?.presentCreateAccountViewFromViewController(loginView!)
    }
    
    func presentForgotPassword() {
        forgotPasswordWireframe?.presentForgotPasswordViewFromViewController(loginView!)
    }
    
    func loginViewController() -> LoginView {
        let viewcontroller = mainStoryBoard().instantiateViewController(withIdentifier: loginViewIdentifier) as! LoginView
        return viewcontroller
    }
}

extension LoginWireframe: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = (loginView?.view.frame)!
        
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
