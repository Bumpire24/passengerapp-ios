//
//  CheckOutPaymentMethodView.swift
//  BetaProduct-Swift
//
//  Created by Enrico Boller on 10/01/2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

protocol CreditCardInfoModalDelegate {
    func persistCreditCardInformation(creditCardInfo: CardDisplayItem)
    func proceedToCreditCardPaymentMethod()
}

class CheckOutPaymentMethodView: CheckOutViewClasses, CheckOutViewProtocol, CreditCardInfoModalDelegate{
    @IBOutlet weak var paymentMethodListCollection: UICollectionView!
    
    var availablePaymentMethods : [String]?
    var creditCardInformation : CardDisplayItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentMethodListCollection?.dataSource = self
        paymentMethodListCollection?.delegate = self
        eventHandler?.fetchPaymentMethods()
    }
    
    //MARK: CreditCardInfoModalDelegate Method
    func persistCreditCardInformation(creditCardInfo: CardDisplayItem) {
        creditCardInformation = creditCardInfo
        eventHandler?.processCardInfo(cardInfo: creditCardInformation!)
    }
    
    func proceedToCreditCardPaymentMethod() {
        eventHandler?.setSelectedPaymentMethod(withIndex: 0)
    }
    
    //MARK: CheckOutViewProtocol Methods
    func returnAvailablePaymentMethods(availablePaymentMethods: [String]){
        self.availablePaymentMethods = availablePaymentMethods
    }
    
    func proceedToNextStep() {
        delegate?.executeNextStep(nextPageNumber: .Step03)
    }
    
    func verificationFailed(withMessage message: String) {
        super.displayDialogMessage(withTitle: "Check Out",
                                   messageContent: message,
                                   affirmativeButtonCaption: "OK",
                                   currentViewController: self,
                                   messageStatus: false)
        proceedToNextStep()
    }
    
    @IBAction func paymentMethodSelected(_ sender: UIButton) {
        guard sender.titleLabel?.text == "PayPal" else {
            checkOutWireframe?.presentCheckOutCreditCardModalViewFromViewController(self)
            return
        }
        
        eventHandler?.setSelectedPaymentMethod(withIndex: availablePaymentMethods!.index(of: sender.titleLabel!.text!)!)
    }
    
}

extension CheckOutPaymentMethodView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let paymentMethodsListCount = availablePaymentMethods?.count != nil ? availablePaymentMethods?.count : 0
        return paymentMethodsListCount!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = paymentMethodListCollection.dequeueReusableCell(withReuseIdentifier: "checkOutPaymentMethodsCell", for: indexPath) as! CheckOutPaymentMethodCollectionViewCell
        DispatchQueue.global(qos: .userInitiated).async {
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                cell.paymentMethodButton.setTitle(self.availablePaymentMethods?[indexPath.item], for: .normal)
                cell.paymentMethodButton.addTarget(self, action: #selector(self.paymentMethodSelected), for: .touchUpInside)
                let paymentMethodIcon = self.availablePaymentMethods?[indexPath.item]
                switch paymentMethodIcon {
                  case "PayPal"? :
                    cell.paymentMethodIcon.image = UIImage(named: paymentMethodIcon!)
                default :
                    cell.paymentMethodIcon.image = UIImage(named: "defaultPaymentMethod.png")
                }
            }
        }
        
        return cell
    }
}

extension CheckOutPaymentMethodView : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}
