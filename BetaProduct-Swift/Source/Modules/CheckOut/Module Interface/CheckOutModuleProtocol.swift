//
//  CheckOutModuleProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

/// module interface protocol for module `Check Out`
protocol CheckOutModuleProtocol {
    /// display shipping details
    func getShippingDetail()
    /**
     manually add a different shipping address
     - Parameters:
        - preferredShippingAddress: manual shipping address
     */
    func setShippingAddress(preferredShippingAddress : String)
    /// displays a list of payment methods
    func fetchPaymentMethods()
    /**
     selects the payment methods target from the list
     - Parameters:
        - index: index target in payment list
     */
    func setSelectedPaymentMethod(withIndex index: Int)
    /**
     passes card information to be used
     - Parameters:
        - cardInfo: card information view model
     */
    func processCardInfo(cardInfo : CardDisplayItem)
    /// displays billing information
    func getBillingInformation()
    /// displays terms and conditions
    func getTermsAndConditions()
    /// toggles button to accepts terms and conditions
    func termsAccepted()
    /// toggles buttons to decline terms and conditons
    func termsRejected()
    /// displays summary
    func getSummary()
    /// process payment
    func proceedWithPayment()
}
