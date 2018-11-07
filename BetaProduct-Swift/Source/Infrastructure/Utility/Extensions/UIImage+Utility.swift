//
//  UIImage+Utility.swift
//  BetaProduct-Swift
//
//  Created by User on 12/21/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import Alamofire

extension UIImage {
    func createAlamofireImage(withURLString urlString: String, completionClosure: @escaping (_ imageReturned : UIImage) -> Void) {
        let remoteImageURL = URL(string: urlString)
        
        Alamofire.request(remoteImageURL!).responseData { (response) in
            if response.error == nil {
                if let data = response.data {
                    let downloadedImage = UIImage(data: data) != nil ? UIImage(data: data)! : UIImage(named: "NoPreviewImage.png")
                    completionClosure(downloadedImage!)
                }
            }
        }
    }
}
