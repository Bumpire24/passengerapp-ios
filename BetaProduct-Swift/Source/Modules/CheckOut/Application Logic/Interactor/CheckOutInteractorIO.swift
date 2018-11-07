//
//  File.swift
//  BetaProduct-Swift
//
//  Created by User on 1/2/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

/// interactor input protocol for module `Check Out`
protocol CheckOutInteractorInput {
    // shipping
    /// retrieves user shipping address
    func getShippingDetails()
    /**
     manually add a different shipping address for user
     - Parameters:
        - address: manual address
     */
    func useShippingAddress(_ address: String)
    /// validates shipping address selected by the user
    func validateShippingAndTryToProceedToPayment()
    // payment methods
    /// retrieves all posssible payment methods that the user can make use of
    func getPaymentMethods()
    /**
     selectes payment method chosen by user from the given list
     - Parameters:
        - index: target index in the given list
     */
    func usePaymentMethodByIndex(_ index: Int)
    /**
     adds a card for payment if user selects card payment
     - Parameters:
        - card: card view model
     */
    func useCard(_ card: CardDisplayItem)
    /// validates chosen payment method
    func validatePaymentAndTryToProceedToBilling()
    // billing details
    /// retrieves billing details
    func getBillingDetails()
    // terms and conditions
    /// retrieves Terms and Conditions
    func getTermsAndConditions()
    /// toggleable accept terms
    func acceptTerms()
    /// toggleable decline terms
    func declineTerms()
    /// validates terms
    func validateTermsAndTryToProceedToSummary()
    // get summary details
    /// retrieves summary details
    func getSummary()
    /// validates payment and executes transaction
    func processPay()
}

/// interactor output protocol for module `Check Out`
protocol CheckOutInteractorOutput {
    /**
     returns results from interactor validations
     - Parameters:
         - isSuccess: boolean response
         - message: message from result
     */
    func processComplete(wasSuccessful isSuccess: Bool, withMessage message: String?)
    /**
     returned user shipping details
     - Parameters:
        - shippingDetails: user shipping address
     */
    func gotShippingDetails(_ shippingDetails: String)
    /**
     returns all payment methods
     - Parameters:
        - paymentMethods: string array of payment methods for display
     */
    func gotPaymentMethods(_ paymentMethods: [String])
    /**
     returned user billing details
     - Parameters:
        - billingDetails: user billing details
     */
    func gotBillingDetails(_ billingDetails: String)
    /**
     returned terms and conditions
     - Parameters:
        - termsAndConditions: terms and conditions
     */
    func gotTermsAndConditions(_ termsAndConditions: String)
    /**
     returned summary details
     - Parameters:
        - summary: summary details
     */
    func gotSummary(_ summary: String)
}
