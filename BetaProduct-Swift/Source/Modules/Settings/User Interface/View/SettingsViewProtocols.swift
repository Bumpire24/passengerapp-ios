//
//  SettingsViewProtocols.swift
//  BetaProduct-Swift
//
//  Created by User on 12/5/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsViewProtocol {
    func displayMessage(_ message : String, isSuccessful : Bool)
}

protocol SettingsProfileViewProtocol: SettingsViewProtocol {
    func populateUserProfile(displayItems: SettingsProfileDisplayItem)
    /// updates profile image
    func updateViewWithNewProfileImage(image: UIImage)
}
