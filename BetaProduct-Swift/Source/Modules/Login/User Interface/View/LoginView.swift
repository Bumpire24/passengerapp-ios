//
//  LoginView.swift
//  BetaProduct-Swift
//
//  Created by User on 11/9/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree

class LoginView: BaseView, BaseViewProtocol, LoginViewProtocol {
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var loginHeaderLabel: IDoohHeaderLabel!
    @IBOutlet weak var loginInstructionsLabel: IDoohInstructionLabel!
    @IBOutlet weak var loginButton: IDoohPrimaryButton!
    @IBOutlet weak var createAccountButton: IDoohLinkButton!
    @IBOutlet weak var separatorButton: IDoohLinkButton!
    @IBOutlet weak var forgotPasswordButton: IDoohLinkButton!
    @IBOutlet weak var emailField: IDoohRoundedContainerTextField!
    @IBOutlet weak var passwordField: IDoohRoundedContainerTextField!
    var eventHandler : LogInModuleProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        populateControls()
        enableTapGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: LoginViewProtocol
    func displayMessage(_ message: String, isSuccessful: Bool) {
        guard isSuccessful else {
            super.displayDialogMessage(withTitle: "Login",
                                       messageContent: message,
                                       affirmativeButtonCaption: "OK",
                                       currentViewController: self,
                                       messageStatus: isSuccessful)
            return
        }
        eventHandler?.proceedToHomeView()
    }
    
    @IBAction func login(_ sender: Any) {
        let user = UserDisplayItem.init(email: emailField.text, password: passwordField.text)
        eventHandler?.validateUser(user)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        eventHandler?.proceedToCreateAccount()
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        eventHandler?.proceedToForgotPassword()
    }
}

extension LoginView {
    func populateControls() {
        self.loginButton.setTitle("Login", for: .normal)
        self.forgotPasswordButton.setTitle("Forgot password?", for: .normal)
        self.createAccountButton.setTitle("Create account", for: .normal)
        self.emailField.placeholder = "email"
        self.passwordField.placeholder = "password"
        self.emailField.text = ""
        self.passwordField.text = ""
        
        //For Testing Only
//        emailField.text = "sample@sample.com"
//        passwordField.text = "~Pezhetairoi24"
//        emailField.text = "er.enrique@gmail.com"
//        passwordField.text = "EREnrique@123456"
    }
}
