//
//  ChangePasswordView.swift
//  BetaProduct-Swift
//
//  Created by User on 11/28/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ChangePasswordView: BaseView, SettingsViewProtocol {
    @IBOutlet weak var changePasswordHeaderLabel: IDoohHeaderLabel!
    @IBOutlet weak var changePasswordInstructionLabel: IDoohInstructionLabel!
    @IBOutlet weak var oldPasswordView: IDoohRoundedTextFieldContainer!
    @IBOutlet weak var oldPasswordImageView: UIImageView!
    @IBOutlet weak var oldPasswordField: IDoohRoundedContainerTextField!
    @IBOutlet weak var oldPasswordButton: IDoohEditButton!
    @IBOutlet weak var newPasswordView: IDoohRoundedTextFieldContainer!
    @IBOutlet weak var newPasswordImageView: UIImageView!
    @IBOutlet weak var newPasswordField: IDoohRoundedContainerTextField!
    @IBOutlet weak var newPasswordButton: IDoohEditButton!
    @IBOutlet weak var confirmPasswordView: IDoohRoundedTextFieldContainer!
    @IBOutlet weak var confirmPasswordImageView: UIImageView!
    @IBOutlet weak var confirmPasswordField: IDoohRoundedContainerTextField!
    @IBOutlet weak var confirmPasswordButton: IDoohEditButton!
    @IBOutlet weak var changePasswordSaveButton: IDoohPrimaryButton!
    @IBOutlet weak var changePasswordCancelButton: IDoohSecondaryButton!
    @IBOutlet weak var changePasswordOrLabel: UILabel!
    var eventHandler : SettingsUpdateModuleProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        defineUIControlDefaultState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI State functions
    
    func defineUIControlDefaultState() {
        changePasswordSaveButton.isHidden = true
        changePasswordCancelButton.isHidden = true
        changePasswordOrLabel.isHidden = true
        oldPasswordField.isEnabled = false
        oldPasswordButton.isEnabled = true
        newPasswordField.isEnabled = false
        newPasswordButton.isEnabled = true
        confirmPasswordField.isEnabled = false
        confirmPasswordButton.isEnabled = true
    }
    
    func defineUIControlState(shouldEnable: Bool, forField: IDoohRoundedContainerTextField, withAssociatedEditButton: UIButton) {
        forField.isEnabled = shouldEnable
        withAssociatedEditButton.isEnabled = !shouldEnable
    }
    
    func defineButtonsVisibility(visibilityState: Bool) {
        changePasswordSaveButton.isHidden = visibilityState
        changePasswordCancelButton.isHidden = visibilityState
        changePasswordOrLabel.isHidden = visibilityState
    }
    
    //MARK: IBOutlet functions
    
    @IBAction func editOldPassword(_ sender: Any) {
        defineUIControlState(shouldEnable: true, forField: oldPasswordField, withAssociatedEditButton: oldPasswordButton)
        defineButtonsVisibility(visibilityState: false)
        super.specifyFirstResponder(buttonControl:  oldPasswordField)
    }
    
    @IBAction func editNewPassword(_ sender: Any) {
        defineUIControlState(shouldEnable: true, forField: newPasswordField, withAssociatedEditButton: newPasswordButton)
        defineButtonsVisibility(visibilityState: false)
        super.specifyFirstResponder(buttonControl:  newPasswordField)
    }
    
    @IBAction func editConfirmPassword(_ sender: Any) {
        defineUIControlState(shouldEnable: true, forField: confirmPasswordField, withAssociatedEditButton: confirmPasswordButton)
        defineButtonsVisibility(visibilityState: false)
        super.specifyFirstResponder(buttonControl:  confirmPasswordField)
    }
    
    @IBAction func savePasswordChanges(_ sender: Any) {
        var displayItems = SettingsPasswordDisplayItem()
        displayItems.passwordOld = oldPasswordField.text
        displayItems.passwordNew = newPasswordField.text
        displayItems.passwordNewConfirm = confirmPasswordField.text
        eventHandler?.saveUpdates(withItem: displayItems)
        defineUIControlDefaultState()
    }
    
    @IBAction func revertPasswordChanges(_ sender: Any) {
        defineUIControlDefaultState()
    }
    
    func displayMessage(_ message: String, isSuccessful: Bool) {
        super.displayDialogMessage(withTitle: "Change Password",
                                   messageContent: message,
                                   affirmativeButtonCaption: "OK",
                                   currentViewController: self,
                                   messageStatus: isSuccessful)
        
    }
}
