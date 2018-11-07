//
//  Product.swift
//  BetaProduct-Swift
//
//  Created by User on 11/9/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

/// model for Product. Implements ModelProtocol
struct Product : ModelProtocol {
    var status: Int16 = Status.Active.toInt16()
    var syncStatus: Int16 = SyncStatus.Created.toInt16()
    var createdAt: Date = Date()
    var modifiedAt: Date = Date()
    var col1: String = ""
    var col2: String = ""
    var col3: String = ""
    var name: String = ""
    var weblink: String = ""
    var productDescription: String = ""
    var price: Double = 0.00
    var priceDescription: String = ""
    var imageUrl: String = ""
    var imageThumbUrl: String = ""
    var imageCompanyUrl: String = ""
    var productId: Int = -1
    var productAddedInCart: Bool = false
    var addedAt: Date = Date()
}

/// extension for model Product
extension Product {
    /**
     parameterized init for Product
     - Parameters:
         - productName: product name
         - productId: product id
         - productPrice: product price. Just in Double
         - productPriceDescription: product currency used
         - productWeblink: product website link
         - productImageURL: product image
         - productImageThumbURL: product image thumb version
         - productImageCompanyURL: product company image
     */
    init(productName: String,
         productDescription: String,
         productId: Int,
         productPrice: Double,
         productPriceDescription: String,
         productWeblink: String,
         productImageURL: String,
         productImageThumbURL: String,
         productImageCompanyURL: String) {
        self.name = productName
        self.productDescription = productDescription
        self.productId = productId
        self.price = productPrice
        self.priceDescription = productPriceDescription
        self.weblink = productWeblink
        self.imageUrl = productImageURL
        self.imageThumbUrl = productImageThumbURL
        self.imageCompanyUrl = productImageCompanyURL
    }
    
    /**
     parameterized init for Product
     - Parameters:
        - dataDict: dictionary parameter. For webservice parsing
     */
    init(dictionary dataDict: [String: Any]) {
        let wsConverter = WebServiceConverter.init(dataDict)
        self.name = wsConverter.stringWithKey("name")
        self.productDescription = wsConverter.stringWithKey("description")
        self.productId = wsConverter.intWithKey("id")
        self.price = wsConverter.doubleWithKey("price")
        self.priceDescription = wsConverter.stringWithKey("currency")
//        self.weblink = wsConverter.stringWithKey("url")
        self.imageUrl = wsConverter.stringWithKey("image_high")
        self.imageThumbUrl = wsConverter.stringWithKey("image_thumb")
        self.imageCompanyUrl = wsConverter.stringWithKey("image_high")
        self.createdAt = wsConverter.dateWithKey("created_at")
        self.modifiedAt = wsConverter.dateWithKey("updated_at")
//        let media_gallery_entries = dataDict["media_gallery_entries"] as! [[String: Any]]
//        let mediaData = media_gallery_entries.first!
//        let imageURL = mediaData["file"] as! String
//        self.name = wsConverter.stringWithKey("name")
//        self.productDescription = "This is a test"
//        self.productId = wsConverter.intWithKey("id")
//        self.price = wsConverter.doubleWithKey("price")
//        self.priceDescription = "$"
//        self.weblink = ""
//        self.imageUrl = "http://127.0.0.1/magento2/pub/media/catalog/product" + imageURL
//        self.imageThumbUrl = "http://127.0.0.1/magento2/pub/media/catalog/product" + imageURL
//        self.imageCompanyUrl = "http://127.0.0.1/magento2/pub/media/catalog/product" + imageURL
    }
}
