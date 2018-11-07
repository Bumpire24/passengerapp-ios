//
//  CheckOutInteractor.swift
//  BetaProduct-Swift
//
//  Created by User on 1/2/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Braintree
import BraintreeDropIn

/// interactor class for module `Check Out`
class CheckOutInteractor: CheckOutInteractorInput {
    var webservice: StoreWebClientProtocol?
    var output: CheckOutInteractorOutput?
    var session: Session?
    var manager: ShopCartManager?
    var braintreeAPIClient: BTAPIClient?
    var managerHistory: HistoryManager?
    
    enum PaymentMethod : String {
        case Card = "Credit or Debit Card",
        PayPal = "PayPal"
        
        static func makeArrayString() -> [String] {
            return [self.Card.rawValue, self.PayPal.rawValue]
        }
        
        static func makeArray() -> [PaymentMethod] {
            return [self.Card, self.PayPal]
        }
    }
    
    private var shippingAddress: String?
    private var paymentMethods: [PaymentMethod] = PaymentMethod.makeArray()
    private var selectedPayMethod: PaymentMethod?
    private var card: CardDisplayItem?
    private var termsAndConditionsAccepted = false
    private var nonce: String?
    private var cart: [ShopCart]?
    
    // MARK: CheckOutInteractorInput
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func getShippingDetails() {
        output?.gotShippingDetails(session?.user?.addShipping ?? "")
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func useShippingAddress(_ address: String) {
        shippingAddress = address
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func validateShippingAndTryToProceedToPayment() {
        if shippingAddress == nil {
            output?.processComplete(wasSuccessful: false, withMessage: "No Shipping Address Selected!")
        } else {
            output?.processComplete(wasSuccessful: true, withMessage: nil)
        }
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func getPaymentMethods() {
        output?.gotPaymentMethods(PaymentMethod.makeArrayString())
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func usePaymentMethodByIndex(_ index: Int) {
        selectedPayMethod = paymentMethods[index]
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func useCard(_ card: CardDisplayItem) {
        self.card = card
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func validatePaymentAndTryToProceedToBilling() {
        guard let nonNilSelectedPayMethod = selectedPayMethod else {
            output?.processComplete(wasSuccessful: false, withMessage: "No Payment Method Selected!")
            return
        }
        
        guard let nonNilSession = session else {
            self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
            return
        }
        
        if selectedPayMethod == PaymentMethod.Card {
            guard let _ = card?.number, let _ = card?.expirationMonth, let _ = card?.expirationYear else {
                self.output?.processComplete(wasSuccessful: false, withMessage: "Card is incorrect!")
                return
            }
        }
            
        // Get Shop Cart
        manager?.retrieveShopCart(withUser: nonNilSession.getUserSessionAsUser(), withCompletionBlock: { response in
            switch response {
            case .success(let cart):
                // Request Token
                self.webservice?.GET(iDooh.kWSOrdersToken(), parameters: nil, block: { response in
                    switch response {
                    case .success(let value):
                        // Request nonce
                        if let list = value, let targetUser = list.first, let converted = targetUser as? [String:Any] {
                            let token = converted["token"] as! String
                            guard let nonNilAPIClient = BTAPIClient.init(authorization: token) else {
                                self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
                                return
                            }
                            switch nonNilSelectedPayMethod {
                            case .Card:
                                let client = BTCardClient.init(apiClient: nonNilAPIClient)
                                let card = BTCard.init(number: self.card!.number!, expirationMonth: self.card!.expirationMonth!, expirationYear: self.card!.expirationYear!, cvv: self.card?.cvv)
                                client.tokenizeCard(card, completion: { cardNonce, error in
                                    if error != nil {
                                        self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
                                    } else {
                                        self.nonce = cardNonce!.nonce
                                        self.cart = cart!
                                        self.output?.processComplete(wasSuccessful: true, withMessage: nil)
                                    }
                                })
                            case .PayPal:
                                let payPalDriver = BTPayPalDriver.init(apiClient: nonNilAPIClient)
                                payPalDriver.viewControllerPresentingDelegate = self.output as? BTViewControllerPresentingDelegate
                                payPalDriver.authorizeAccount(completion: { (nonce, error) in
                                    if error != nil {
                                        self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
                                    } else {
                                        if let nonce = nonce {
                                            self.nonce = nonce.nonce
                                            self.cart = cart!
                                            self.output?.processComplete(wasSuccessful: true, withMessage: nil)
                                        }
                                    }
                                })
                            }
                            
                        } else {
                            self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
                        }
                    case .failure(_): self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
                    }
                })
            case .failure(_): self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
            }
        })
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func getBillingDetails() {
        output?.gotBillingDetails("What is Lorem Ipsum?" +
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." +
            
            "Why do we use it?" +
            "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)." +
            
            
            "Where does it come from?" +
            "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32." +
            
            "The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham." +
            
            "Where can I get some?" +
            "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.")
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func getTermsAndConditions() {
        output?.gotTermsAndConditions("What is Lorem Ipsum?" +
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." +
            
            "Why do we use it?" +
            "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)." +
            
            
            "Where does it come from?" +
            "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32." +
            
            "The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham." +
            
            "Where can I get some?" +
            "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.")
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func acceptTerms() {
        termsAndConditionsAccepted = true
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func declineTerms() {
        termsAndConditionsAccepted = false
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func validateTermsAndTryToProceedToSummary() {
        if termsAndConditionsAccepted {
            output?.processComplete(wasSuccessful: true, withMessage: nil)
        } else {
            output?.processComplete(wasSuccessful: false, withMessage: "Terms And Conditions not accepted!")
        }
    }
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func getSummary() {
        output?.gotSummary("What is Lorem Ipsum?" +
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." +
            
            "Why do we use it?" +
            "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)." +
            
            
            "Where does it come from?" +
            "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32." +
            
            "The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham." +
            
            "Where can I get some?" +
            "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.")
    }
    
    /**
     UseCase:
     retrieve cart and make order model
     call service and make order
     call service and make the transaction
     save the order to core
     clear cart
     **/
    
    /// implements Protocol `CheckOutInteractorInput` see `CheckOutInteractorIO.swift`
    func processPay() {
        // make order
        var order = makeOrderFromShopCart(cart!)
        // Call Service to make Order
        self.webservice?.POST(iDooh.KWSUsersOrders(withID: String(self.session!.getUserSessionAsUser().id)), parameters: self.dataDictionaryFromOrder(order), block: { response in
            switch response {
            case .success(let value):
                if let nonNilValue = value,
                    let rawDataDict = nonNilValue.first as? [String: Any],
                    let orderId = rawDataDict["id"] as? Int,
                    let orderItems = rawDataDict["order_items"] as? [[String: Any]] {
                    order.orderId = orderId
                    for (index, element) in order.items.enumerated() {
                        if let found = orderItems.first(where: {$0["product_id"] as! Int == element.productId}) {
                            order.items[index].productId = found["product_id"] as! Int
                            order.items[index].currency = found["currency"] as! String
                            order.items[index].productImage = found["product_image"] as! String
                        }
                    }
                    // save order
                    self.managerHistory?.createOrder(withOrder: order, withUserEmail: self.session!.getUserSessionAsUser().email, withCompletionBlock: { response in
                        switch response {
                        case .success(_):
                            // Clear Shop Cart Data
                            self.manager?.deleteAll(withUser: self.session!.getUserSessionAsUser(), withCompletionBlock: { _ in
                                self.clearVariables()
                                self.output?.processComplete(wasSuccessful: true, withMessage: "Transaction Complete!")
                            })
                        case .failure(_): self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
                        }
                    })
//                    // Call Service to conduct transaction
//                    self.webservice?.POST(iDooh.kWebServicePayBaseURL,
//                                          parameters: self.dataDictionaryFromOrderForPayment(order: order),
//                                          block: { response in
//                        switch response {
//                        case .success(_):
//                            // save order
//                            self.managerHistory?.createOrder(withOrder: order, withUserEmail: self.session!.getUserSessionAsUser().email, withCompletionBlock: { response in
//                                switch response {
//                                case .success(_):
//                                    // Clear Shop Cart Data
//                                    self.manager?.deleteAll(withUser: self.session!.getUserSessionAsUser(), withCompletionBlock: { _ in
//                                        self.clearVariables()
//                                        self.output?.processComplete(wasSuccessful: true, withMessage: "Transaction Complete!")
//                                    })
//                                case .failure(_): self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
//                                }
//                            })
//                        case .failure(_): self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
//                        }
//                    })
                } else {
                    iDoohError.logError(message: "Unable to parse Data")
                    self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
                }
            case .failure(let error):
                iDoohError.logError(withiDoohError: error)
                self.output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage)
            }
        })
    }
    
    /// clears variables used in checkout to reuse module for the next new batch of transactions
    private func clearVariables() {
        shippingAddress = nil
        selectedPayMethod = nil
        card = nil
        termsAndConditionsAccepted = false
        nonce = nil
        cart = nil
    }
    
    /**
     creates a Checkout Model from the given inputs
     - Parameters:
         - cart: array of ShopCart
         - nonce: generated nonce (Braintree)
     - Returns: checkout model
     */
    private func CheckOutFromShopCart(_ cart: [ShopCart], andNonce nonce: String) -> Order {
        var checkOut = Order()
        checkOut.items = [OrderItem]()
        checkOut.nonce = nonce
        for shopCart in cart {
            var checkOutItem = OrderItem()
            checkOutItem.productId = shopCart.productId
            checkOutItem.quantity = Int(shopCart.quantity)
            checkOutItem.price = shopCart.product.price
            checkOutItem.productName = shopCart.product.name
            checkOut.items.append(checkOutItem)
        }
        return checkOut
    }
    
    private func makeOrderFromShopCart(_ cart: [ShopCart]) -> Order{
        var value = Order()
        value.userId = Int(session!.getUserSessionAsUser().id)
        for shopCart in cart {
            var checkOutItem = OrderItem()
            checkOutItem.productId = shopCart.productId
            checkOutItem.quantity = Int(shopCart.quantity)
            checkOutItem.price = shopCart.product.price
            checkOutItem.productName = shopCart.product.name
            value.items.append(checkOutItem)
        }
        return value
    }
    
    private func dataDictionaryFromOrder(_ order: Order) -> [String: Any] {
        var dataDict = [String: Any]()
        var value = [String: Any]()
        var valueItems = [[String: Any]]()
        value["user_id"] = order.userId
        value["nonce"] = nonce!
        order.items.forEach { orderItem in
            var valueItem = [String: Any]()
            valueItem["product_id"] = orderItem.productId
            valueItem["price"] = orderItem.price
            valueItem["quantity"] = orderItem.quantity
            valueItem["product_name"] = orderItem.productName
            valueItems.append(valueItem)
        }
        value["order_items"] = valueItems
        dataDict["order"] = value
        return dataDict
    }
    
    private func dataDictionaryFromOrderForPayment(order: Order) -> [String: Any] {
        return ["nonce": nonce!, "totalPrice": order.totalPrice]
    }
}
