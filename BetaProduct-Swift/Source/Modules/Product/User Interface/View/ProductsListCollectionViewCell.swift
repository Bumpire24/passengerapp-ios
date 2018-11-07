//
//  ProductsListCollectionViewCell.swift
//  BetaProduct-Swift
//
//  Created by User on 12/14/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ProductsListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: IDoohProductNameLabel!
    @IBOutlet weak var productDescription: IDoohProductDescriptionLabel!
    @IBOutlet weak var productButton: UIButton!
    
    var product: ProductListItem? {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        if let product = product {
            let imageURL = URL(string: (product.imageURL)!)
            let imageData = try!Data(contentsOf: imageURL!)
            productImageView.image = UIImage(data: imageData, scale: UIScreen.main.scale)!
            productName.text = product.name
            productDescription.text = product.description
        } else {
            productImageView.image = nil
            productName.text = nil
            productDescription.backgroundColor = nil
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
    
    @IBAction func displayProductDetail(_ sender: Any) {
        
    }
    
}
