//
//  CheckOutView.swift
//  BetaProduct-Swift
//
//  Created by User on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CheckOutView: CheckOutViewClasses, CheckOutViewProtocol {
    @IBOutlet weak var originalShippingAddress: IDoohRegularContainerTextView!
    @IBOutlet weak var newPreferredShippingAddress: IDoohRegularContainerTextView!
    @IBOutlet var existingShippingAddressCheckBox: UIButton!
    @IBOutlet var newShippingAddressCheckBox: UIButton!
    @IBOutlet weak var nextButton: IDoohDialogPrimaryButton!
    var fetchedShippingAddress : String?
    var dialogMessage = "Please Select A Shipping Address"
    var dialogTitle = "Check Out"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getShippingInformation()
        specifyNewShippingAddressPlaceHolder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Check Out View Protocol Methods
    func getShippingInformation() {
        eventHandler?.getShippingDetail()
    }
    
    func displayShippingInformation(fetchedShippingInformation : String) {
        fetchedShippingAddress = fetchedShippingInformation
        guard fetchedShippingAddress!.isEmpty else {
            originalShippingAddress.placeHolder.isHidden = true
            originalShippingAddress.text = fetchedShippingAddress
            specifyOriginalShippingAddressCheckboxAsDefault()
            return
        }
        
        originalShippingAddress.placeHolder.isHidden = false
        originalShippingAddress.placeHolder.text = "Your Shipping Address is Empty"
    }
    
    func proceedToNextStep() {
        delegate?.executeNextStep(nextPageNumber: .Step02)
    }
    
    func verificationFailed(withMessage message: String) {
        super.displayDialogMessage(withTitle: dialogTitle,
                                   messageContent: message,
                                   affirmativeButtonCaption: "OK",
                                   currentViewController: self,
                                   messageStatus: false)
    }
    
    //MARK: Action Methods
    @IBAction func checkBoxPressed(_ sender: UIButton) {
        if(sender == existingShippingAddressCheckBox) {
            guard fetchedShippingAddress!.isEmpty else {
                toggleCheckBox(onTargetCheckBox: existingShippingAddressCheckBox)
                toggleNewPreferredShippingAddressField(shouldEnable: false)
                fetchedShippingAddress = originalShippingAddress.text
                
                return
            }
        } else {
            toggleCheckBox(onTargetCheckBox: newShippingAddressCheckBox)
            toggleNewPreferredShippingAddressField(shouldEnable: true)
            fetchedShippingAddress = newPreferredShippingAddress.text
            dialogMessage = "Your New Shipping Address is Empty"
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        var message : String = String()
        if(existingShippingAddressCheckBox.tag == 1) {
            guard originalShippingAddress.text.isEmpty else {
                eventHandler?.setShippingAddress(
                    preferredShippingAddress: originalShippingAddress.text)
                return
            }
        } else {
            guard newPreferredShippingAddress.text.isEmpty else {
                eventHandler?.setShippingAddress(
                    preferredShippingAddress: newPreferredShippingAddress.text)
                return
            }
            message = "Your New Shipping Address is Empty"
            displayMessage(message: message)
            return
        }
        
        message = "Please Select A Shipping Address"
        displayMessage(message: message)
    }
    
    //MARK: Helper Methods
    func displayMessage(message: String) {
        super.displayDialogMessage(withTitle: dialogTitle,
                                   messageContent: message,
                                   affirmativeButtonCaption: "OK",
                                   currentViewController: self,
                                   messageStatus: false)
    }
    
    func specifyOriginalShippingAddressCheckboxAsDefault() {
        toggleCheckBox(onTargetCheckBox: existingShippingAddressCheckBox)
        toggleNewPreferredShippingAddressField(shouldEnable: false)
    }
    
    func specifyNewShippingAddressPlaceHolder() {
        newPreferredShippingAddress.placeHolder.text = "New Shipping Address"
    }
    
    func toggleCheckBox(onTargetCheckBox checkBoxItem: UIButton) {
        if(checkBoxItem == existingShippingAddressCheckBox) {
            existingShippingAddressCheckBox.setImage(UIImage(named: "boxChecked.png"), for: .normal)
            existingShippingAddressCheckBox.tag = 1
            newShippingAddressCheckBox.setImage(UIImage(named: "boxUnchecked.png"), for: .normal)
            newShippingAddressCheckBox.tag = 0
        } else {
            existingShippingAddressCheckBox.setImage(UIImage(named: "boxUnchecked.png"), for: .normal)
            existingShippingAddressCheckBox.tag = 0
            newShippingAddressCheckBox.setImage(UIImage(named: "boxChecked.png"), for: .normal)
            newShippingAddressCheckBox.tag = 1
        }
    }
    
    func toggleNewPreferredShippingAddressField(shouldEnable : Bool) {
        newPreferredShippingAddress.isEditable = shouldEnable
        newPreferredShippingAddress.placeHolder.isHidden = shouldEnable
        if(!shouldEnable) {
            newPreferredShippingAddress.text = ""
        }
    }
}
