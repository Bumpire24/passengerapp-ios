//
//  SettingsPresenterHome.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/28/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// presenter class for module "Settings"
class SettingsPresenterHome: NSObject, SettingsHomeModuleProtocol, SettingsHomeInteractorOuput {
    /// variable for interactor
    var interactor: SettingsInteractorInput?
    /// variable for wireframe
    var wireframeSettings : SettingsWireframe?
    /// variablw for view
    var view: String?
    
    // MARK: SettingsHomeModuleProtocol
    /// implements protocol. see `SettingsInteractorIO.swift`
    func proceedToProfileSettings() {
        wireframeSettings?.presentProfileSettings()
    }
    
    /// implements protocol. see `SettingsInteractorIO.swift`
    func proceedToPaswordSettings() {
        wireframeSettings?.presentChangePasswordSettings()
    }
    
    /// implements protocol. see `SettingsInteractorIO.swift`
    func proceedToEmailSettings() {
        wireframeSettings?.presentChangeEmailSettings()
    }
    
    /// implements protocol. see `SettingsInteractorIO.swift`
    func logout() {
        self.interactor?.logOut()
    }
    
    // MARK: SettingsHomeInteractorOuput
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func logOutReady() {
        wireframeSettings?.logOutUser()
    }
    
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func gotDisplayItem<T>(_ item: T) where T : SettingsDisplayItemProtocol {
        
    }
}
