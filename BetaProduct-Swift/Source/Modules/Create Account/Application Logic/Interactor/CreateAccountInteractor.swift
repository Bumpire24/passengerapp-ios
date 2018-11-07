//
//  CreateAccountInteractor.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/17/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// interactor class for module `Create Account`
class CreateAccountInteractor : NSObject, CreateAccountInteractorInput {
    /// variable for create account data manager
    var createAccountManager : UserManager?
    /// variable for output delegate
    var output : CreateAccountInteractorOutput?
    /// variable for webservice
    var webService : StoreWebClientProtocol?
    
    // MARK: Privates
    /// validate Email. calls isInputValid for generic input validation
    private func isEmailValid(email: String) -> Bool {
        return isInputValid(input:email) && email.isValidEmail()
    }
    
    /// validate Password. calls isInputValid for generic input validation
    private func isPasswordValid(password: String) -> Bool {
        // TODO: Password Encryption
        return isInputValid(input: password)
    }
    
    /// validate mobile. calls isInputValid for generic input validation
    private func isMobileValid(mobile: String) -> Bool {
        return isInputValid(input: mobile) && mobile.isValidPhone()
    }
    
    /// validate name. calls isInputValid for generic input validation
    private func isNameValid(name: String) -> Bool {
        return isInputValid(input: name)
    }
    
    /// validate address. calls isInputValid for generic input validation
    private func isAddressValid(address: String) -> Bool {
        return isInputValid(input: address)
    }
    
    // validate inputs. Generic handle for input validations
    private func isInputValid(input: String) -> Bool {
        if input.count == 0 {
            return false
        }
        return true
    }
    
    // MARK: CreateAccountInteractorInput
    // use case
    // validate Account Credentials
    // retrieve account with the given input
    // check email nil, email whitespace, valid email
    // check password nil, password whitespace
    // check mobile nil, mobile whitespace, valid mobile
    // check name nil, name whitespace
    // call WS
    // check account if valid for creation
    
    /// implements protocol. see `CreateAccountInteractorIO.swift`
    func validateAccountCredentials(_ loginDisplay: UserCredentialsItem) {
        
        // validate inputs
        guard let lastName = loginDisplay.lastName?.trimmingCharacters(in: .whitespacesAndNewlines), isNameValid(name: lastName) else {
            output?.createAccountSuccessful(false, message: "Last Name incorrect!")
            return
        }
        
        guard let firstName = loginDisplay.firstName?.trimmingCharacters(in: .whitespacesAndNewlines), isNameValid(name: firstName) else {
            output?.createAccountSuccessful(false, message: "First Name incorrect!")
            return
        }
        
        guard let middleName = loginDisplay.middleName?.trimmingCharacters(in: .whitespacesAndNewlines), isNameValid(name: middleName) else {
            output?.createAccountSuccessful(false, message: "Middle Name incorrect!")
            return
        }
        
        guard let shippingAddress = loginDisplay.shippingAddress?.trimmingCharacters(in: .whitespacesAndNewlines), isNameValid(name: shippingAddress) else {
            output?.createAccountSuccessful(false, message: "Shipping Address incorrect!")
            return
        }
        
//        guard let mobileNumber = loginDisplay.mobileNumber?.trimmingCharacters(in: .whitespacesAndNewlines), isMobileValid(mobile: mobileNumber) else {
//            output?.createAccountSuccessful(false, message: "Mobile Number incorrect!")
//            return
//        }
        
        guard let username = loginDisplay.email?.trimmingCharacters(in: .whitespacesAndNewlines), isEmailValid(email: username) else {
            output?.createAccountSuccessful(false, message: "Email incorrect!")
            return
        }
        
        guard let password = loginDisplay.password?.trimmingCharacters(in: .whitespacesAndNewlines), isPasswordValid(password: password) else {
            output?.createAccountSuccessful(false, message: "Password incorrect!")
            return
        }
        
        // call WS and validate account
        webService?.POST(iDooh.kWSUsers(), parameters: makeJSONDictionaryFromViewModel(model: loginDisplay), block: { response in
            switch response {
            case .success(_):
                self.output?.createAccountSuccessful(true, message: "Account creation Successful!")
            case .failure(let error):
                self.output?.createAccountSuccessful(false, message: (error?.localizedFailureReason)!)
            }
        })
    }
    
    /**
     converts view model data to Dictionary as JSON for URL Requests
     - Parameters:
        - model: view model target.
     - Returns: converted Dictionary accepted by the webservice as parameter
     */
    private func makeJSONDictionaryFromViewModel(model: UserCredentialsItem) -> [String: Any] {
        var dataDict = [String: Any]()
        var userDataDict = [String: Any]()
        userDataDict["first_name"] = model.firstName
        userDataDict["middle_name"] = model.middleName
        userDataDict["last_name"] = model.lastName
        userDataDict["email"] = model.email
        userDataDict["shipping_address"] = model.shippingAddress
        dataDict["user"] = userDataDict
        dataDict["password"] = model.password
        return dataDict
    }
}
