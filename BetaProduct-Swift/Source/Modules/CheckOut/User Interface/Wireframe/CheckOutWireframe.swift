//
//  CheckOutWireframe.swift
//  BetaProduct-Swift
//
//  Created by User on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

let checkOutViewIdentifier = "CheckOutView"
let checkOutPaymentViewIdentifier = "CheckOutPaymentMethodView"
let checkOutCreditCardPaymentMethodViewIdentifier = "CheckOutCreditCardPaymentMethodView"
let checkOutBillingInfoViewIdentifier = "CheckOutBillingInfoView"
let checkOutTermsAndConditionsViewIdentifier = "CheckOutTermsAndConditionsView"
let checkOutSummaryViewIdentifier = "CheckOutSummaryView"
let checkOutPageViewControllerIdentifier = "CheckOutPageView"

class CheckOutWireframe: BaseWireframe {
    var shopCartWireframe : ShopCartWireframe?
    var homeWireframe : HomeWireframe?
    var checkOutPageView : CheckOutPageViewController?
    var checkOutView : CheckOutView?
    var checkOutPaymentMethodView : CheckOutPaymentMethodView?
    var checkOutCreditCardInfoModalView : CheckOutCardModalView?
    var checkOutBillingInfoView : CheckOutBillingInfoView?
    var checkOutTermsAndConditionsView : CheckOutTermsAndConditionsView?
    var checkOutSummaryView : CheckOutSummaryView?
    var presenter : CheckOutPresenter?
    
    func presentCheckOutPageViewFromViewController(_ viewController: UIViewController) {
        let newViewController = checkOutPageViewController()
        checkOutPageView = newViewController
        checkOutPageView?.eventHandler = presenter
        checkOutPageView?.checkOutWireframe = self
        checkOutPageView?.homeWireFrame = homeWireframe
        checkOutPageView?.presenter = presenter
        viewController.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func presentCheckOutCreditCardModalViewFromViewController(_ viewController: UIViewController) {
        let newViewController = checkOutCreditCardModalViewController()
        checkOutCreditCardInfoModalView = newViewController
//        newViewController.delegate = checkOutPaymentMethodView
        newViewController.delegate = viewController as? CreditCardInfoModalDelegate
        viewController.navigationController?.present(newViewController, animated: true, completion: nil)
    }
    
    func checkOutCreditCardModalViewController() -> CheckOutCardModalView {
        let checkOutViewController = mainStoryBoard().instantiateViewController(withIdentifier: checkOutCreditCardPaymentMethodViewIdentifier) as! CheckOutCardModalView
        return checkOutViewController
    }
    
    func checkOutPageViewController() -> CheckOutPageViewController {
        let checkOutViewController = mainStoryBoard().instantiateViewController(withIdentifier: checkOutPageViewControllerIdentifier) as! CheckOutPageViewController
        return checkOutViewController
    }

    func presentPayPalView(_ viewcontroller: UIViewController) {
        checkOutView?.present(viewcontroller, animated: true, completion: nil)
    }
    
    func dismissPayPalView(_ viewcontroller: UIViewController) {
        viewcontroller.dismiss(animated: true, completion: nil)
    }
    
    
}
