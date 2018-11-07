//
//  QRCodeInteractorIO.swift
//  BetaProduct-Swift
//
//  Created by User on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol QRCodeInteractorInput {
    func processQRCodeAndFindProduct(_ value: String)
    func configureCameraWithFrame(_ frame: CGRect)
    func startCamera()
    func stopCamera()
    func findMetaDataObjectinCameraLayer(_ metaDataObject: AVMetadataObject)
}

protocol QRCodeInteractorOutput {
    func foundMetaDataObject(_ qrObject: AVMetadataObject)
    func cameraConfigurationComplete(wasSuccessful isSuccess: Bool, withMessage message: String, withCameraLayer cameraLayer: CALayer?)
    func processComplete(wasSuccessful isSuccess: Bool, withMessage message: String, withProductID productId: Int?)
}
