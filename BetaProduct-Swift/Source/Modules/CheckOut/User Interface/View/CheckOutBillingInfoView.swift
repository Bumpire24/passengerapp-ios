//
//  CheckOutBillingInfoView.swift
//  BetaProduct-Swift
//
//  Created by User on 1/11/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CheckOutBillingInfoView: CheckOutViewClasses, CheckOutViewProtocol {
    @IBOutlet weak var billingInfoTextView: IDoohRegularContainerTextView!
    var billingInformationRetrieved = true
    var dialogMessage = "Your Billing Information can't be retrieved"
    var dialogTitle = "Check Out"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBillingInformation()        
    }
    
    func fetchBillingInformation() {
        eventHandler?.getBillingInformation()
    }
    
    //MARK: CheckOutViewProtocol Methods
    
    func displayBillingInformation(billingInformation : String){
        guard billingInformation.isEmpty else {
            billingInfoTextView.placeHolder.isHidden = true
            billingInfoTextView.text = billingInformation
            billingInformationRetrieved = true
            return
        }
        
        billingInfoTextView.placeHolder.isHidden = false
        billingInfoTextView.placeHolder.text = "Your Billing Information is Empty"
        billingInformationRetrieved = false
    }

    func proceedToNextStep() {
        delegate?.executeNextStep(nextPageNumber: .Step04)
    }
    
    func verificationFailed(withMessage message: String) {
        //super.displayDialogMessage(withTitle: "Check Out", messageContent: message, affirmativeButtonCaption: "OK", currentViewController: self, messageStatus: false, successCompletion: {}, failureCompletion: {})
        displayMessage(message: message)
    }
    
    @IBAction func proceedToTermsAndConditions(_ sender: Any) {
        proceedToNextStep()
    }
    
    //MARK: Helper Methods
    func displayMessage(message: String) {
        super.displayDialogMessage(withTitle: dialogTitle,
                                   messageContent: message,
                                   affirmativeButtonCaption: "OK",
                                   currentViewController: self,
                                   messageStatus: false)
    }
}
