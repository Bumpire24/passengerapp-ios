//
//  CheckOutViewProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol CheckOutViewProtocol {
    func getShippingInformation()
    func displayShippingInformation(fetchedShippingInformation : String)
    func returnAvailablePaymentMethods(availablePaymentMethods: [String])
    func displayBillingInformation(billingInformation : String)
    func displayTermsAndConditions(termsAndConditions : String)
    func displaySummary(summaryInfo : String)
    func proceedToNextStep()
    func verificationFailed(withMessage message: String)
}

extension CheckOutViewProtocol {
    ///MARK: Optional Methods
    func getShippingInformation() {}
    func displayShippingInformation(fetchedShippingInformation : String) {}
    func returnAvailablePaymentMethods(availablePaymentMethods: [String]){}
    func displayBillingInformation(billingInformation : String){}
    func displayTermsAndConditions(termsAndConditions : String){}
    func displaySummary(summaryInfo : String){}
}
