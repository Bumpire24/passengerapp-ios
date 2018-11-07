//
//  SettingsModuleInterface.swift
//  BetaProduct-Swift
//
//  Created by User on 11/27/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// module interface for module `Settings`
protocol SettingsHomeModuleProtocol {
    /// navigate to Profile Settings
    func proceedToProfileSettings()
    /// navigate to Password Settings
    func proceedToPaswordSettings()
    /// navigate to Email Settings
    func proceedToEmailSettings()
    /// log out user and navigate to login
    func logout()
}

/// module interface for module `Settings`
protocol SettingsUpdateModuleProtocol {
    /// save pending updates
    func saveUpdates<T: SettingsDisplayItemProtocol>(withItem item: T)
    /// cancel pending updates
    func cancelUpdates()
}

/// module interface for module `Settings`
protocol SettingsProfileModuleProtocol: SettingsUpdateModuleProtocol{
    /// opens Camera
    func proceedToCamera()
    /// opens Photo Library
    func proceedToPhotoLibrary()
    /// fetches view model
    func updateView()
}
