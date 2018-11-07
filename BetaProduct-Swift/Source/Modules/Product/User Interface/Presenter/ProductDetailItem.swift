//
//  ProductDetailItem.swift
//  BetaProduct-Swift
//
//  Created by User on 12/8/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// view model for Module `Product`
struct ProductDetailItem: BaseDisplayItem {
    let id: Int?
    let name: String?
    let description: String?
    let price: String?
    let priceDescription: String?
    let imageURL: String?
    let imageThumbURL: String?
    let imageCompanyURL: String?
    let companyWeblink: String?
    let isAddedToShopCart: Bool?
}
