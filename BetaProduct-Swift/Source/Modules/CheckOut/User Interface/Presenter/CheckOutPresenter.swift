//
//  CheckOutPresenter.swift
//  BetaProduct-Swift
//
//  Created by User on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Braintree

/// presenter class for module `Check Out`
class CheckOutPresenter: NSObject, CheckOutModuleProtocol, CheckOutInteractorOutput, BTViewControllerPresentingDelegate {
    /// variable for view
    var view : CheckOutViewProtocol?
    /// variable for interactor
    var interactor : CheckOutInteractorInput?
    /// variable for wireframe
    var wireframeCheckOut : CheckOutWireframe?
    
    // MARK: CheckOutModuleProtocol
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func getShippingDetail() {
        interactor?.getShippingDetails()
    }
    
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func setShippingAddress(preferredShippingAddress : String) {
        interactor?.useShippingAddress(preferredShippingAddress)
        interactor?.validateShippingAndTryToProceedToPayment()
    }
    
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func fetchPaymentMethods() {
        interactor?.getPaymentMethods()
    }
    
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func setSelectedPaymentMethod(withIndex index: Int) {
        interactor?.usePaymentMethodByIndex(index)
        interactor?.validatePaymentAndTryToProceedToBilling()
    }
    
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func getBillingInformation() {
        interactor?.getBillingDetails()
    }
    
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func processCardInfo(cardInfo: CardDisplayItem) {
        interactor?.useCard(cardInfo)
    }
    
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func getTermsAndConditions() {
        interactor?.getTermsAndConditions()
    }
    
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func termsAccepted() {
        interactor?.acceptTerms()
        interactor?.validateTermsAndTryToProceedToSummary()
    }
    
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func termsRejected() {
        interactor?.declineTerms()
        interactor?.validateTermsAndTryToProceedToSummary()
    }
    
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func getSummary() {
        interactor?.getSummary()
    }
    
    /// implements Protocol `CheckOutModuleProtocol` see `CheckOutModuleProtocol.swift`
    func proceedWithPayment() {
        interactor?.processPay()
    }
    
    // MARK: CheckOutInteractorOutput
    /// implements Protocol `CheckOutInteractorOutput` see `CheckOutInteractorIO.swift`
    func processComplete(wasSuccessful isSuccess: Bool, withMessage message: String?) {
        guard isSuccess else {
            view?.verificationFailed(withMessage: message!)
            return
        }
        view?.proceedToNextStep()
    }
    
    /// implements Protocol `CheckOutInteractorOutput` see `CheckOutInteractorIO.swift`
    func gotShippingDetails(_ shippingDetails: String) {
        view?.displayShippingInformation(fetchedShippingInformation: shippingDetails)
    }
    
    /// implements Protocol `CheckOutInteractorOutput` see `CheckOutInteractorIO.swift`
    func gotPaymentMethods(_ paymentMethods: [String]) {
        view?.returnAvailablePaymentMethods(availablePaymentMethods: paymentMethods)
    }
    
    /// implements Protocol `CheckOutInteractorOutput` see `CheckOutInteractorIO.swift`
    func gotBillingDetails(_ billingDetails: String) {
        view?.displayBillingInformation(billingInformation: billingDetails)
    }
    
    /// implements Protocol `CheckOutInteractorOutput` see `CheckOutInteractorIO.swift`
    func gotTermsAndConditions(_ termsAndConditions: String) {
        view?.displayTermsAndConditions(termsAndConditions: termsAndConditions)
    }
    
    /// implements Protocol `CheckOutInteractorOutput` see `CheckOutInteractorIO.swift`
    func gotSummary(_ summary: String) {
        view?.displaySummary(summaryInfo: summary)
    }
    
    // MARK: BTViewControllerPresentingDelegate
    /// implemetns Protocol `BTViewControllerPresentingDelegate` (BrainTree Library)
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        wireframeCheckOut?.presentPayPalView(viewController)
    }
    
    /// implemetns Protocol `BTViewControllerPresentingDelegate` (BrainTree Library)
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        wireframeCheckOut?.dismissPayPalView(viewController)
    }
}
