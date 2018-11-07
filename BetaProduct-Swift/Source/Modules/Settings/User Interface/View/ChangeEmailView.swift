//
//  ChangeEmailView.swift
//  BetaProduct-Swift
//
//  Created by User on 11/28/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ChangeEmailView: BaseView, SettingsViewProtocol {
    @IBOutlet weak var changeEmailHeaderLabel: IDoohHeaderLabel!
    @IBOutlet weak var changeEmailInstructionLabel: IDoohInstructionLabel!
    @IBOutlet weak var oldEmailAddressView: IDoohRoundedContainerView!
    @IBOutlet weak var oldEmailImageView: UIImageView!
    @IBOutlet weak var oldEmailAddressField: IDoohRoundedContainerTextField!
    @IBOutlet weak var oldEmailAddressButton: UIButton!
    @IBOutlet weak var newEmailAddressView: IDoohRoundedContainerView!
    @IBOutlet weak var newEmailImageView: UIImageView!
    @IBOutlet weak var newEmailAddressField: IDoohRoundedContainerTextField!
    @IBOutlet weak var newEmailAddressButton: UIButton!
    @IBOutlet weak var confirmEmailAddressView: IDoohRoundedContainerView!
    @IBOutlet weak var confirmEmailImageView: UIImageView!
    @IBOutlet weak var confirmEmailAddressField: IDoohRoundedContainerTextField!
    @IBOutlet weak var confirmEmailAddressButton: UIButton!
    @IBOutlet weak var changeEmailAddressSaveButton: IDoohPrimaryButton!
    @IBOutlet weak var changeEmailAddressCancelButton: IDoohSecondaryButton!
    @IBOutlet weak var changeEmailOrLabel: UILabel!
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
        changeEmailAddressSaveButton.isHidden = true
        changeEmailAddressCancelButton.isHidden = true
        changeEmailOrLabel.isHidden = true
        oldEmailAddressField.isEnabled = false
        newEmailAddressField.isEnabled = false
        confirmEmailAddressField.isEnabled = false
        oldEmailAddressButton.isEnabled = true
        newEmailAddressButton.isEnabled = true
        confirmEmailAddressButton.isEnabled = true
    }
    
    func defineUIControlState(shouldEnable: Bool, forField: IDoohRoundedContainerTextField, withAssociatedEditButton: UIButton) {
        forField.isEnabled = shouldEnable
        withAssociatedEditButton.isEnabled = !shouldEnable
    }
    
    func defineButtonsVisibility(visibilityState: Bool) {
        changeEmailAddressSaveButton.isHidden = visibilityState
        changeEmailAddressCancelButton.isHidden = visibilityState
        changeEmailOrLabel.isHidden = visibilityState
    }
    
    //MARK: IBOutlet functions
    
    @IBAction func editOldEmail(_ sender: Any) {
        defineUIControlState(shouldEnable: true, forField: oldEmailAddressField, withAssociatedEditButton: oldEmailAddressButton)
        defineButtonsVisibility(visibilityState: false)
        super.specifyFirstResponder(buttonControl:  oldEmailAddressField)
    }
    
    @IBAction func editNewEmail(_ sender: Any) {
        defineUIControlState(shouldEnable: true, forField: newEmailAddressField, withAssociatedEditButton: newEmailAddressButton)
        defineButtonsVisibility(visibilityState: false)
        super.specifyFirstResponder(buttonControl:  newEmailAddressField)
    }
    
    @IBAction func editConfirmEmail(_ sender: Any) {
        defineUIControlState(shouldEnable: true, forField: confirmEmailAddressField, withAssociatedEditButton: confirmEmailAddressButton)
        defineButtonsVisibility(visibilityState: false)
        super.specifyFirstResponder(buttonControl:  confirmEmailAddressField)
    }
    
    @IBAction func saveEmailChanges(_ sender: Any) {
        var displayItems = SettingsEmailDisplayItem()
        displayItems.emailAddOld = oldEmailAddressField.text
        displayItems.emailAddNew = newEmailAddressField.text
        displayItems.emailAddNewConfirm = confirmEmailAddressField.text
        eventHandler?.saveUpdates(withItem: displayItems)
        defineUIControlDefaultState()
    }
    
    @IBAction func revertProfileChanges(_ sender: Any) {
        defineUIControlDefaultState()
    }
    
    // MARK: SettingsViewProtocol
    func displayMessage(_ message: String, isSuccessful: Bool) {
        super.displayDialogMessage(withTitle: "Change Email",
                                   messageContent: message,
                                   affirmativeButtonCaption: "OK",
                                   currentViewController: self,
                                   messageStatus: isSuccessful)
        
    }
}
