//
//  SettingsChangePasswordWireframe.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 12/5/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

let changePasswordSettingsViewIdentifier = "ChangePasswordSettingsView"

class SettingsChangePasswordWireframe: BaseWireframe {
    var changePasswordSettingsView : ChangePasswordView?
    var presenter : SettingsPresenterPassword?
    
    func presentChangePasswordSettingsViewFromViewController(_ viewController: UIViewController) {
        let newViewController = changePasswordSettingsViewController()
        changePasswordSettingsView = newViewController
        changePasswordSettingsView?.eventHandler = presenter
        presenter?.changePasswordView  = newViewController
        viewController.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    private func changePasswordSettingsViewController() -> ChangePasswordView {
        let viewcontroller = mainStoryBoard().instantiateViewController(withIdentifier: changePasswordSettingsViewIdentifier) as! ChangePasswordView
        return viewcontroller
    }

}
