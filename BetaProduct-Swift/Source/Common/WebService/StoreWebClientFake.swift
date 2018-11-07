//
//  StoreWebClientFake.swift
//  BetaProduct-Swift
//
//  Created by User on 12/13/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

/// class mock up for a fake service. Implements protocol `StoreWebClientProtocol`
class StoreWebClientFake: StoreWebClientProtocol {
    private var fakeData = [["id": 1,
                             "name": "Ordinary Bag",
                             "description": "Ordinary Bag. What more do you want?",
                             "price": 128.00,
                             "currency": "$",
                             "image_thumbnail_url": "http://assets.myntassets.com/assets/images/1629740/2017/1/18/11484732429611-Mast--Harbour-Women-Handbags-2591484732429302-1.jpg",
                             "image_high_res_url": "http://assets.myntassets.com/assets/images/1629740/2017/1/18/11484732429611-Mast--Harbour-Women-Handbags-2591484732429302-1.jpg"],
                            ["id": 2,
                             "name": "Another Bag",
                             "description": "Another Bag. What more do you want?",
                             "price": 135.00,
                             "currency": "$",
                             "image_thumbnail_url": "http://belk.scene7.com/is/image/Belk?layer=0&src=2600368_38312_A_279_T10L00&layer=comp&$DWP_PRODUCT_ZOOM_DESKTOP$",
                             "image_high_res_url": "http://belk.scene7.com/is/image/Belk?layer=0&src=2600368_38312_A_279_T10L00&layer=comp&$DWP_PRODUCT_ZOOM_DESKTOP$"],
                            ["id": 3,
                             "name": "Still Another Bag",
                             "description": "Yay! More Bag......",
                             "price": 101.99,
                             "currency": "$",
                             "image_thumbnail_url": "https://www.strandbags.com.au/stores/PRODUCTS/160060/ATTRFILE_LRG1/colorado_3d_weave_tote_3169951.jpg",
                             "image_high_res_url": "https://www.strandbags.com.au/stores/PRODUCTS/160060/ATTRFILE_LRG1/colorado_3d_weave_tote_3169951.jpg"]]
    
    func PATCH(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
        
    }
    
    func GET(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
        if url == iDooh.kWSProducts() {
            block(.success(fakeData))
        } else {
            let prodId = Int(url.components(separatedBy: "/").last!)
            block(.success([fakeData[prodId! - 1]]))
        }
    }
    
    func PUT(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
        
    }
    
    func POST(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
            block(.success([["email": "er_test1@gmail.com", "password": "123456"]]))
    }
    
    func DELETE(_ url: String, parameters: [String : Any]?, block: @escaping (Response<[Any]>) -> Void) {
        
    }
    
    func UploadImage(asData data: Data, toURL url: String, WithCompletionBlock block: @escaping (Response<[Any]>) -> Void) {
        
    }
}
