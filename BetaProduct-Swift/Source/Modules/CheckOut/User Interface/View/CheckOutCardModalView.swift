//
//  CheckOutCardModalView.swift
//  BetaProduct-Swift
//
//  Created by User on 1/12/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CheckOutCardModalView: BaseView {
    @IBOutlet weak var creditCardNumber: IDoohRoundedContainerTextField!
    @IBOutlet weak var creditCardExpirationMonth: IDoohRoundedContainerTextField!
    @IBOutlet weak var creditCardExpirationYear: IDoohRoundedContainerTextField!
    @IBOutlet weak var creditCardCVV: IDoohRoundedContainerTextField!
    var delegate : CreditCardInfoModalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func processCreditCardInformation(_ sender: UIButton) {
        let creditCardCredentials = CardDisplayItem.init(number: creditCardNumber.text,
                                                         expirationMonth: creditCardExpirationMonth.text,
                                                         expirationYear: creditCardExpirationYear.text,
                                                         cvv: creditCardCVV.text)
        
        self.delegate?.persistCreditCardInformation(creditCardInfo: creditCardCredentials)
        
        self.dismiss(animated: true, completion: {
            self.delegate?.proceedToCreditCardPaymentMethod()
        })
    }
    
}
