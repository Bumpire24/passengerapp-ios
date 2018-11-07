//
//  SettingsPresenterPassword.swift
//  BetaProduct-Swift
//
//  Created by User on 11/28/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

/// presenter class for module `Settings`
class SettingsPresenterPassword: NSObject, SettingsUpdateModuleProtocol, SettingsPasswordInteractorOutput {
    /// variable for interactor
    var interactor: SettingsInteractorInput?
    /// variable for wireframe
    var changePasswordSettingsWireframe : SettingsChangePasswordWireframe?
    /// variable for view
    var changePasswordView: SettingsViewProtocol?
    
    // MARK: SettingsUpdateModuleProtocol
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func saveUpdates<T>(withItem item: T) where T : SettingsDisplayItemProtocol {
        self.interactor?.validateAndUpdateSettings(usingDisplayitem: item)
    }
    
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func cancelUpdates() {
        
    }
    
    func settingsUpdationComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        changePasswordView?.displayMessage(message, isSuccessful: isSuccess)
    }
}
