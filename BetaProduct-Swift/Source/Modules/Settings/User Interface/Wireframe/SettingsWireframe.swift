//
//  SettingsWireframe.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/27/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

let settingsViewIdentifier = "SettingsView"

class SettingsWireframe: BaseWireframe {
    var settingsView : SettingsView?
    var rootWireFrame : RootWireframe?
    var profileSettingsWireframe : SettingsProfileWireframe?
    var changeEmailSettingsWireframe : SettingsChangeEmailWireframe?
    var changePasswordSettingsWireframe : SettingsChangePasswordWireframe?
    var homeWireFrame : HomeWireframe?
    var settingsPresenter : SettingsPresenterHome?
    
    func presentSettingsViewFromViewController(_ viewController: UIViewController) {
        let newViewController = settingsViewController()
        settingsView = newViewController
        settingsView?.eventHandler = settingsPresenter
        settingsPresenter?.view = newViewController.description
        viewController.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func presentProfileSettings() {
        profileSettingsWireframe?.presentProfileSettingsViewFromViewController(settingsView!)
    }
    
    func presentChangeEmailSettings() {
        changeEmailSettingsWireframe?.presentChangeEmailSettingsViewFromViewController(settingsView!)
    }
    
    func presentChangePasswordSettings() {
        changePasswordSettingsWireframe?.presentChangePasswordSettingsViewFromViewController(settingsView!)
    }
    
    func logOutUser() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let appDependencies = AppDependencies()
        appDependencies.installRootViewController(InWindow: appDelegate.window!)
    }
    
    func settingsViewController() -> SettingsView {
        let viewcontroller = mainStoryBoard().instantiateViewController(withIdentifier: settingsViewIdentifier) as! SettingsView
        return viewcontroller
    }
}
