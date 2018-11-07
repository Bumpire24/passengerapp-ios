//
//  SettingsChangeEmailWireframe.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 12/4/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

let changeEmailSettingsViewIdentifier = "ChangeEmailSettingsView"

class SettingsChangeEmailWireframe: BaseWireframe {
    var changeEmailSettingsView : ChangeEmailView?
    var presenter : SettingsPresenterEmail?
    
    func presentChangeEmailSettingsViewFromViewController(_ viewController: UIViewController) {
        let newViewController = changeEmailSettingsViewController()
        changeEmailSettingsView = newViewController
        changeEmailSettingsView?.eventHandler = presenter
        presenter?.changeEmailView  = newViewController
        viewController.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    private func changeEmailSettingsViewController() -> ChangeEmailView {
        let viewcontroller = mainStoryBoard().instantiateViewController(withIdentifier: changeEmailSettingsViewIdentifier) as! ChangeEmailView
        return viewcontroller
    }
}
