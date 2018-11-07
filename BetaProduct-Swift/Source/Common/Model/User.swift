//
//  User.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// model for User. Implements ModelProtocol
struct User : ModelProtocol {
    var id: Int16 = -1
    var firstName: String = ""
    var middleName: String = ""
    var lastName: String = ""
    /// variable for status. see Status Enum
    var status: Int16 = Int16(Status.Active.rawValue)
    /// variable for sync status. see SyncStatus Enum
    var syncStatus: Int16 = Int16(SyncStatus.Created.rawValue)
    /// variable for created date
    var createdAt: Date = Date()
    /// variable for modified date
    var modifiedAt: Date = Date()
    /// variable for extra column
    var col1: String = ""
    /// variable for extra column
    var col2: String = ""
    /// variable for extra column
    var col3: String = ""
    /// variable for email
    var email: String = ""
    /// variable for mobile/phone
    var mobile: String = ""
    /// variable for shipping address
    var addressShipping : String = ""
    /// variable for profile image url
    var profileImageURL : String = ""
    var password: String = ""
}

/// extension for model User
extension User {
    var fullname: String { get {
        return firstName + " " + middleName + " " + lastName
        }}
    
    /**
     parameterized init for User
     - Parameters:
         - userID: user id
         - email: user valid email address
         - lname: user last name
         - fName: user first name
         - mName: user middle name
         - addShip: user shippinh address
     */
    init(withUserID userID: Int16, withEmailAddress email: String, withLastName lname: String, withFirstName fName: String, withMiddleName mName: String, withAddressShipping addShip: String) {
        self.id = userID
        self.email = email
        self.lastName = lname
        self.firstName = fName
        self.middleName = mName
        self.addressShipping = addShip
    }
    
    /**
     parameterized init for User
     - Parameters:
         - userID: user id
         - email: user valid email address
         - password: user password
         - lname: user last name
         - fName: user first name
         - mName: user middle name
         - addShip: user shippinh address
     */
    init(withUserID userID: Int16, withEmailAddress email: String, withPassword password: String, withLastName lname: String, withFirstName fName: String, withMiddleName mName: String, withAddressShipping addShip: String) {
        self.init(withUserID: userID, withEmailAddress: email, withLastName: lname, withFirstName: fName, withMiddleName: mName, withAddressShipping: addShip)
        self.password = password
    }
    
    /**
     parameterized init for User
     - Parameters:
        - dataDict: dictionary parameter. For webservice parsing
     */
    init(dictionary dataDict: [String: Any]) {
        let wsConverter = WebServiceConverter.init(dataDict)
        self.email = wsConverter.stringWithKey("email")
        self.lastName = wsConverter.stringWithKey("last_name")
        self.middleName = wsConverter.stringWithKey("middle_name")
        self.firstName = wsConverter.stringWithKey("first_name")
        self.id = wsConverter.int16WithKey("id")
        self.addressShipping = wsConverter.stringWithKey("shipping_address")
        self.createdAt = wsConverter.dateWithKey("created_at")
        self.modifiedAt = wsConverter.dateWithKey("updated_at")
        self.profileImageURL = wsConverter.stringWithKey("customer_image")
    }
}
