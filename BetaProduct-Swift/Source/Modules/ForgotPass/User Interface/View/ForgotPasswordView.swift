//
//  ForgotPasswordView.swift
//  BetaProduct-Swift
//
//  Created by User on 2/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class ForgotPasswordView: BaseView, BaseViewProtocol, ForgotPasswordViewProtocol {
    @IBOutlet var forgotPasswordView: UIView!
    @IBOutlet weak var headerLabel: IDoohHeaderLabel!
    @IBOutlet weak var instructionsLabel: IDoohInstructionLabel!
    @IBOutlet weak var emailField: IDoohRoundedContainerTextField!
    @IBOutlet weak var retrievePasswordButton: IDoohPrimaryButton!
    
    var eventHandler : ForgotPassModuleProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateControls()
    }
    
    func displayMessage(_ message: String, wasPasswordRetrievalSuccesful wasSuccessful: Bool) {
        guard wasSuccessful else {
            super.displayDialogMessage(withTitle: "Forgot Password",
                                       messageContent: message,
                                       affirmativeButtonCaption: "OK",
                                       currentViewController: self,
                                       messageStatus: wasSuccessful)
            return
        }
        
        super.displayDialogMessage(withTitle: "Forgot Password",
                                   messageContent: message,
                                   affirmativeButtonCaption: "OK",
                                   currentViewController: self,
                                   messageStatus: wasSuccessful)
        eventHandler?.proceedToLogin()
    }
    
    @IBAction func retrievePassword(_ sender: Any) {
        eventHandler?.validateEmailAddress(emailField.text ?? "")
    }
}

extension ForgotPasswordView {
    func populateControls() {
        self.emailField.placeholder = "email"
        self.retrievePasswordButton.setTitle("Retrieve Password", for: .normal)
        self.emailField.text = ""
    }
}
