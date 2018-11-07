//
//  LogInInteractor.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit

/// interactor class for Module 'Login'
class LogInInteractor: NSObject, LogInInteractorInput {
    /// variable for Session.
    var session : Session?
    /// variable for webservice
    var webService : StoreWebClientProtocol?
    var webServiceMagento: StoreWebClientProtocol?
    /// variable for output delegate
    var output : LogInInteractorOutput?
    /// variable for create account manager
    var manager : UserManager?
    var syncEngine : SyncEngineProtocol?
    
    // MARK: privates
    /// validate Username. calls isInputValid for generic input validation
    private func isUsernameValid(username: String) -> Bool {
        return isInputValid(input:username) && username.isValidEmail()
    }
    
     /// validate Password. calls isInputValid for generic input validation
    private func isPasswordValid(password: String) -> Bool {
        return isInputValid(input: password)
    }
    
    // validate inputs. Generic handle for input validations
    private func isInputValid(input: String) -> Bool {
        if input.count == 0 {
            return false
        }
        return true
    }
    
    // MARK: LogInInteractorInput
    
    // use case
    // validateLogIn
    // retrieve user using given input
    // check username nil, username whitespace, username trim, valid email
    // check password nil, password whitespace, password trim
    // call WS
    // authenticate account
    // check if account exists in db
    // insert new record
    // Save User to Session
    
    /// implements protocol. see 'LogInInteractorIO.swift'
    func validateUserLogin(userDisplayItem user: UserDisplayItem) {
        // TODO: ADD Updated date check
        
        // validate inputs
        guard let username = user.email?.trimmingCharacters(in: .whitespacesAndNewlines), isUsernameValid(username: username) else {
            output?.userLoginValidationComplete(wasSuccessful: false, withMessage: "Username incorrect!")
            return
        }
        
        guard let password = user.password?.trimmingCharacters(in: .whitespacesAndNewlines), isPasswordValid(password: password) else {
            output?.userLoginValidationComplete(wasSuccessful: false, withMessage: "Password incorrect!")
            return
        }
        
        webService?.POST(iDooh.kWSSessions(withEmail: username,
                                           andWithPassword: password,
                                           andWithDeviceID: iDooh.udidString()), parameters: nil, block: { response in
            switch response {
            case .success(let value):
                let token = Token.init(dictionary: value?.first as! [String: Any])
                let user = User.init(dictionary: value?.first as! [String: Any])
                self.session?.setToken(token)
                self.manager?.retrieveUser(withEmail: username, withCompletionBlock: { response in
                    switch response {
                    case .success(let userData):
                        self.syncEngine?.syncUser(withUserNew: user, withUserOld: userData!, withCompletionBlock: { _ in
                            self.session?.setUserSessionByUser(user)
                            self.output?.userLoginValidationComplete(wasSuccessful: true, withMessage: "Log in success!")
                        })
                    case .failure(_):
                        self.manager?.createAccount(withUser: user, withCompletionBlock: { response in
                            self.session?.setUserSessionByUser(user)
                            self.output?.userLoginValidationComplete(wasSuccessful: true, withMessage: "Log in success!")
                        })
                    }
                })
//                self.webService?.GET(iDooh.kWSUsers(withID: String(token.userId)), parameters: nil, block: { response in
//                    switch response {
//                    case .success(let value):
//                    case .failure(let error):
//                        self.output?.userLoginValidationComplete(wasSuccessful: false, withMessage: (error?.localizedFailureReason)!)
//                    }
//                })

            case .failure(let error):
                self.output?.userLoginValidationComplete(wasSuccessful: false, withMessage: (error?.localizedFailureReason)!)
            }
        })
    }
}
