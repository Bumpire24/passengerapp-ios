//
//  OrderHistoryTableViewCell.swift
//  BetaProduct-Swift
//
//  Created by User on 2/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {
    //Headers
    @IBOutlet weak var orderDate: IDoohOrderHistoryHeaderLabel!
    @IBOutlet weak var totalOrderPrice: IDoohOrderHistoryFooterLabel!
    
    
    //Contents
    @IBOutlet weak var productName: IdoohShopCartDescriptionLabel!
    @IBOutlet weak var productStatus: IdoohShopCartDescriptionLabel!
    @IBOutlet weak var productAmount: IdoohShopCartDescriptionLabel!
    @IBOutlet weak var orderedItemsSeparator: UIView!
    @IBOutlet weak var productImageThumbnail: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
