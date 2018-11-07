//
//  CheckOutSummaryView.swift
//  BetaProduct-Swift
//
//  Created by User on 1/11/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CheckOutSummaryView: CheckOutViewClasses, CheckOutViewProtocol {
    @IBOutlet weak var SummaryView: IDoohRegularContainerTextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        eventHandler?.getSummary()
    }
    
    func displaySummary(summaryInfo: String) {
        guard summaryInfo.isEmpty else {
            SummaryView.placeHolder.isHidden = true
            SummaryView.text = summaryInfo
            return
        }
        
        SummaryView.placeHolder.isHidden = false
        SummaryView.placeHolder.text = "The Summary Information is Empty"
    }

    //MARK: CheckOutViewProtocol Methods
    func proceedToNextStep() {
        homeWireFrame?.presentHomeViewFromViewController(self)
    }
    
    func verificationFailed(withMessage message: String) {
        super.displayDialogMessage(withTitle: "Check Out",
                                   messageContent: message,
                                   affirmativeButtonCaption: "OK",
                                   currentViewController: self,
                                   messageStatus: false)
    }
    
    //MARK: Action Methods
    @IBAction func proceedToPay(_ sender: Any) {
        eventHandler?.proceedWithPayment()
    }
}
