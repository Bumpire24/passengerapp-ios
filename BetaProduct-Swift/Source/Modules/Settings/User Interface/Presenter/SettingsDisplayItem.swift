//
//  SettingsDisplayItem.swift
//  BetaProduct-Swift
//
//  Created by User on 11/27/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

protocol SettingsDisplayItemProtocol: BaseDisplayItem {
    
}

struct SettingsProfileDisplayItem : SettingsDisplayItemProtocol, Equatable {
    /// variable for name
    var name : String?
    var firstName: String?
    var lastName: String?
    var middleName: String?
    /// variable for mobile
    var mobile : String?
    /// variable for shipping address
    var addressShipping : String?
    /// variable for profile image url
    var profileImage : (url: String?, image: UIImage?)
    
    static func ==(lhs: SettingsProfileDisplayItem, rhs: SettingsProfileDisplayItem) -> Bool {
        return lhs.firstName == rhs.firstName && lhs.middleName == rhs.middleName && lhs.lastName == rhs.lastName && lhs.addressShipping == rhs.addressShipping
    }
}

struct SettingsEmailDisplayItem : SettingsDisplayItemProtocol, Equatable {
    /// variable for old email address
    var emailAddOld: String?
    /// variable for new email address
    var emailAddNew: String?
    /// variable for confirm new email address
    var emailAddNewConfirm: String?
    
    static func ==(lhs: SettingsEmailDisplayItem, rhs: SettingsEmailDisplayItem) -> Bool {
        return lhs.emailAddOld == rhs.emailAddOld && lhs.emailAddNew == rhs.emailAddNew && lhs.emailAddNewConfirm == rhs.emailAddNewConfirm
    }
}

struct SettingsPasswordDisplayItem : SettingsDisplayItemProtocol {
    /// variable for old password
    var passwordOld: String?
    /// variable for new password
    var passwordNew: String?
    /// variable for confirm new password
    var passwordNewConfirm: String?
    
    static func ==(lhs: SettingsPasswordDisplayItem, rhs: SettingsPasswordDisplayItem) -> Bool {
        return lhs.passwordOld == rhs.passwordOld && lhs.passwordNew == rhs.passwordNew && lhs.passwordNewConfirm == rhs.passwordNewConfirm
    }
}


