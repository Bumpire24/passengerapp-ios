//
//  CheckOutPaymentMethodCollectionViewCell.swift
//  BetaProduct-Swift
//
//  Created by User on 3/7/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CheckOutPaymentMethodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var paymentMethodButton: IDoohDialogPrimaryButton!
    @IBOutlet weak var paymentMethodIcon: UIImageView!
    
    var paymentMethodItem: String? {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        if let paymentMethodItem = paymentMethodItem {
            paymentMethodIcon.image = UIImage(named: "defaultPaymentMethod.png")
            paymentMethodButton.setTitle(paymentMethodItem, for: .normal)
        } else {
            paymentMethodIcon.image = nil
            paymentMethodButton.setTitle("PaymentMethod", for: .normal)
        }
    }
}
