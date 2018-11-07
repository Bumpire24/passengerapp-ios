//
//  ShopCartListCollectionViewCell.swift
//  BetaProduct-Swift
//
//  Created by Enrico Boller on 26/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ShopCartListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var shopCartItemImageView: UIImageView!
    @IBOutlet weak var shopCartItemName: IDoohProductNameLabel!
    @IBOutlet weak var shopCartDescription: IdoohShopCartDescriptionLabel!
    @IBOutlet weak var shopCartItemProductIDLabel: UILabel!
    @IBOutlet weak var shopCartQuantityView: UIView!
    @IBOutlet weak var shopCartQuantityLabel: IDoohProductDescriptionLabel!
    @IBOutlet weak var shopCartQuantityField: UITextField!
    @IBOutlet weak var shopCartItemPriceField: UITextField!
    @IBOutlet weak var shopCartDecrementButton: IDoohFloatingPrimaryButton!
    @IBOutlet weak var shopCartIncrementButton: IDoohFloatingPrimaryButton!
    
    var shopCartItemProductID : Int?
    
    var shopCartItem: ShopCartDetailDisplayItem? {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        if let shopCartItem = shopCartItem {
            let imageURL = URL(string: (shopCartItem.productImageURL)!)
            let imageData = try!Data(contentsOf: imageURL!)
            shopCartItemImageView.image = UIImage(data: imageData, scale: UIScreen.main.scale)!
            shopCartItemName.text = shopCartItem.productName
            shopCartDescription.text = shopCartItem.productDescription
            shopCartItemProductID = shopCartItem.productId
            shopCartItemProductIDLabel.text =  String(describing: shopCartItemProductID)
        } else {
            shopCartItemImageView.image = nil
            shopCartItemName.text = nil
            shopCartDescription.text = nil
            shopCartItemProductID = 0
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
    }
    
    
}
