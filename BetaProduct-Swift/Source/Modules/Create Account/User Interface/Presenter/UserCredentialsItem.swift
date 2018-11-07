//
//  UserCredentialsItem.swift
//  BetaProduct-Swift
//
//  Created by User on 11/16/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// User view model for module `Create Account`
struct UserCredentialsItem : BaseDisplayItem {
    /// variable for fullname
    let lastName : String?
    let firstName : String?
    let middleName : String?
    /// variable for shipping address
    let shippingAddress : String?
    /// variable for mobile number
    let mobileNumber : String?
    /// variable for email
    let email : String?
    /// variable for password
    let password : String?
}
