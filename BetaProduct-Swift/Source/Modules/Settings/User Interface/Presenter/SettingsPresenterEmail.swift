//
//  SettingsPresenterEmail.swift
//  BetaProduct-Swift
//
//  Created by User on 11/28/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// presenter class for module `Settings`
class SettingsPresenterEmail: NSObject, SettingsUpdateModuleProtocol, SettingsEmailInteractorOutput {
    /// variable for interactor
    var interactor: SettingsInteractorInput?
    /// variable for wireframe
    var changeEmailSettingsWireframe : SettingsChangeEmailWireframe?
    /// variable for view
    var changeEmailView : SettingsViewProtocol?
    
    // MARK: SettingsUpdateModuleProtocol
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func saveUpdates<T>(withItem item: T) where T : SettingsDisplayItemProtocol {
        self.interactor?.validateAndUpdateSettings(usingDisplayitem: item)
    }
    
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func cancelUpdates() {
        
    }
    
    // MARK: SettingsEmailInteractorOutput
    /// implements protocol. see `SettingsInteractorIO.swift`
    func settingsUpdationComplete(wasSuccessful isSuccess: Bool, withMessage message: String) {
        changeEmailView?.displayMessage(message, isSuccessful: isSuccess)
    }
}
