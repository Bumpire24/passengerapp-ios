//
//  CheckOutTermsAndConditionsView.swift
//  BetaProduct-Swift
//
//  Created by User on 1/11/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CheckOutTermsAndConditionsView: CheckOutViewClasses, CheckOutViewProtocol {
    @IBOutlet weak var termsAndConditionsView: IDoohRegularContainerTextView!
    var termsAndConditionsAccepted = true

    override func viewDidLoad() {
        super.viewDidLoad()
        obtainTermsAndConditions()
    }
    
    func obtainTermsAndConditions() {
        eventHandler?.getTermsAndConditions()
    }
    
    //MARK: CheckOutViewProtocol Methods
    func displayTermsAndConditions(termsAndConditions: String) {
        guard termsAndConditions.isEmpty else {
            termsAndConditionsView.placeHolder.isHidden = true
            termsAndConditionsView.text = termsAndConditions
            return
        }
        
        termsAndConditionsView.placeHolder.isHidden = false
        termsAndConditionsView.placeHolder.text = "The Terms and Conditions Content is Empty"
    }
    
    //MARK: CheckOutViewProtocol Methods
    func proceedToNextStep() {
        delegate?.executeNextStep(nextPageNumber: .Step05)
    }
    
    func verificationFailed(withMessage message: String) {
        super.displayDialogMessage(withTitle: "Check Out",
                                   messageContent: message,
                                   affirmativeButtonCaption: "OK",
                                   currentViewController: self,
                                   messageStatus: false)
    }
    
    //MARK: Action Methods
    @IBAction func declineButtonPressed(_ sender: Any) {
        termsAndConditionsAccepted = false
        eventHandler?.termsRejected()
    }
    
    @IBAction func acceptButtonPressed(_ sender: Any) {
        termsAndConditionsAccepted = true
        eventHandler?.termsAccepted()
    }
    
}
