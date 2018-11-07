//
//  CreateAccountView.swift
//  BetaProduct-Swift
//
//  Created by User on 11/16/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class CreateAccountView: BaseView, BaseViewProtocol, CreateAccountViewProtocol, UITextViewDelegate {
    @IBOutlet weak var firstNameField: IDoohRoundedContainerTextField!
    @IBOutlet weak var middleNameField: IDoohRoundedContainerTextField!
    @IBOutlet weak var lastNameField: IDoohRoundedContainerTextField!
    @IBOutlet weak var shippingAddressField: IDoohRoundedContainerTextView!
    @IBOutlet weak var mobileNumberField: IDoohRoundedContainerTextField!
    @IBOutlet weak var emailField: IDoohRoundedContainerTextField!
    @IBOutlet weak var passwordField: IDoohRoundedContainerTextField!
    @IBOutlet weak var createAccountButton: IDoohPrimaryButton!
    @IBOutlet weak var createAccountHeader: IDoohHeaderLabel!
    @IBOutlet weak var createAccountInstructions: IDoohInstructionLabel!
    
    var eventHandler : CreateAccountModuleProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateControls()
        enableTapGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateControls() {
        firstNameField.placeholder = "first name"
        middleNameField.placeholder = "middle name"
        lastNameField.placeholder = "last name"
        shippingAddressField.specifyPlaceHolderText(placeHolder: "shipping address")
        shippingAddressField.isEditable = true
        shippingAddressField.delegate = self
        mobileNumberField.placeholder = "mobile number"
        mobileNumberField.isHidden = true
        mobileNumberField.isEnabled = false
        emailField.placeholder = "email"
        passwordField.placeholder = "password"
        createAccountButton.setTitle("Create Account", for: .normal)
        firstNameField.text = ""
        middleNameField.text = ""
        lastNameField.text = ""
        shippingAddressField.text = ""
        mobileNumberField.text = ""
        emailField.text = ""
        passwordField.text = ""
    }
    
    ///MARK: Action Methods
    @IBAction func createAccount(_ sender: Any) {
        let userCredentials = UserCredentialsItem.init(lastName: lastNameField.text,
                                                       firstName: firstNameField.text,
                                                       middleName: middleNameField.text,
                                                       shippingAddress: shippingAddressField.text,
                                                       mobileNumber: mobileNumberField.text,
                                                       email: emailField.text,
                                                       password: passwordField.text)
        eventHandler?.validateUserCredentials(userCredentials)
    }
    
    func displayMessage(_ message: String, wasAccountCreationSuccesful wasSuccessful: Bool) {
        guard wasSuccessful else {
            super.displayDialogMessage(withTitle: "Create Account",
                                       messageContent: message,
                                       affirmativeButtonCaption: "OK",
                                       currentViewController: self,
                                       messageStatus: wasSuccessful)
            return
        }
        
        displayDialogMessage(withTitle: "Create Account",
                             messageContent: "Your account has been created successfully",
                             affirmativeButtonCaption: "OK",
                             currentViewController: self,
                             messageStatus: true,
                             successCompletion: {
                                self.eventHandler?.proceedToLogin()
                            },
                             failureCompletion: {})
    }
    
    //MARK: TextView Delegate Methods
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if shippingAddressField.placeHolder.isHidden == false
        {
            moveCursorToStart(aTextView: textView)
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        if shippingAddressField.placeHolder.isHidden == true && shippingAddressField.text == ""
        {
            shippingAddressField.placeHolder.isHidden = false
        }
        
        return true
    }
    
    func moveCursorToStart(aTextView: UITextView)
    {
        DispatchQueue.main.async {
            self.applyNonPlaceholderStyle()
        }
    }
    
    func applyNonPlaceholderStyle()
    {
        shippingAddressField.placeHolder.isHidden = true
    }
}
