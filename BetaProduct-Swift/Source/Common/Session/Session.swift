//
//  UserSession.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/21/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// session class for the app
class Session: NSObject {
    /// variable for shared Session. Singleton Pattern
    static let sharedSession = Session()
    private var hasSynced: Bool = false
    
    /// struct declaration for UserSession. Will be the data object class for session User
    struct UserSession {
        /// variable for email
        var email : String?
        /// variable for Full Name
        var fullName : String?
        /// variable for Mobile/Phone Number
        var mobile : String?
        /// variable for Shipping Address
        var addShipping: String?
        /// variable for Profile Image
        var imageURLProfile: String?
        var token: String?
        var tokenType: String?
        var tokenExpiry: Int16?
        var firstName: String?
        var middleName: String?
        var lastName: String?
        var id: Int16?
    }
    
    /// variable for usersession
    var user : UserSession?
    
    /// clears user Session
    func dismissCurrentUser() {
        user = nil
    }
    
    /// sets UserSession by Model User
    func setUserSessionByUser(_ user: User) {
        if self.user == nil {
            self.user = UserSession()
        }
        self.user?.id = user.id
        self.user?.email = user.email
        self.user?.firstName = user.firstName
        self.user?.middleName = user.middleName
        self.user?.lastName = user.lastName
        self.user?.fullName = user.fullname
        self.user?.mobile = user.mobile
        self.user?.addShipping = user.addressShipping
        self.user?.imageURLProfile = user.profileImageURL
    }
    
    /// gets User Model from UserSession
    func getUserSessionAsUser() -> User {
        var value = User()
        value.id = user?.id ?? -1
        value.email = user?.email ?? ""
        value.lastName = user?.lastName ?? ""
        value.firstName = user?.firstName ?? ""
        value.middleName = user?.middleName ?? ""
        value.addressShipping = user?.addShipping ?? ""
        value.profileImageURL = user?.imageURLProfile ?? ""
        return value
    }
    
    /**
     provides token used for webservice auth
     - Returns: Token String
     */
    func getToken() -> String? {
        return user?.token
    }
    
    /**
     assigns token used for webservice auth
     - Parameters:
        - token: string token
     */
    func setToken(_ token: Token?) {
        if self.user == nil {
            self.user = UserSession()
        }
        self.user?.token = token?.accessToken
        self.user?.tokenExpiry = token?.expiresIn
        self.user?.tokenType = token?.tokenType
    }
    
    func hasAlreadySynced() -> Bool {
        return hasSynced
    }
    
    func markSyncCompleted() {
        hasSynced = true
    }
}
