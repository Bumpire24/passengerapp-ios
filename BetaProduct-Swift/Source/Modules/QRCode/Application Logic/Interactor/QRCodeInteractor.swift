//
//  QRCodeInteractor.swift
//  BetaProduct-Swift
//
//  Created by User on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class QRCodeInteractor: NSObject, QRCodeInteractorInput {
    var manager: ProductManager?
    var webservice: StoreWebClientProtocol?
    var session: Session?
    var output: QRCodeInteractorOutput?
    var outputCamera: AVCaptureMetadataOutputObjectsDelegate?
    private var captureSession: AVCaptureSession?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    /*
     Use Case:
     Get Decoded QRCODE
     Validate QRCODE
     Retrieve Product From WS
     Add Product via Manager
     */
    
    // MARK: QRCodeInteractorInput
    func findMetaDataObjectinCameraLayer(_ metaDataObject: AVMetadataObject) {
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metaDataObject)
        output?.foundMetaDataObject(barCodeObject!)
    }
    
    func startCamera() {
        captureSession?.startRunning()
    }
    
    func stopCamera() {
        captureSession?.stopRunning()
    }
    
    func configureCameraWithFrame(_ frame: CGRect) {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            output?.cameraConfigurationComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage, withCameraLayer: nil)
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureMetadataOutput.setMetadataObjectsDelegate(outputCamera, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
         
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            captureSession?.addOutput(captureMetadataOutput)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = frame
            output?.cameraConfigurationComplete(wasSuccessful: true, withMessage: "", withCameraLayer: videoPreviewLayer)
        } catch let error {
            output?.cameraConfigurationComplete(wasSuccessful: false, withMessage: error.localizedDescription, withCameraLayer: nil)
        }
    }
    
    func processQRCodeAndFindProduct(_ value: String) {
        // guard against invalid input
        guard let productId = Int(serviceParameterFromQRDecode(value)) else {
            output?.processComplete(wasSuccessful: false, withMessage: iDooh.kGenericErrorMessage, withProductID: nil)
            return
        }
        
        // Check if Product already exists
        manager?.retrieveProductById(productId, withCompletionBlock: { response in
            switch response {
            case .success(_):
                // Product already exists!
                self.output?.processComplete(wasSuccessful: true,
                                             withMessage: "Product Succesfully Added!",
                                             withProductID: productId)
            case .failure(_):
                // Decode QR Code and Call Webservice
                self.webservice?.GET(iDooh.kWSProducts(withID: self.serviceParameterFromQRDecode(value)),
                                parameters: nil,
                                block: { response in
                                    switch response {
                                    case .success(let valueProduct):
                                        let product = Product.init(dictionary: valueProduct?.first as! [String: Any])
                                        // Add Product to Manager
                                        self.manager?.createProduct(withProduct: product,
                                                                    WithUser: self.session?.getUserSessionAsUser(),
                                                                    withCompletionBlock: { response in
                                                                        switch response {
                                                                        case .success(_):
                                                                            self.output?.processComplete(wasSuccessful: true,
                                                                                                         withMessage: "Product Succesfully Added!",
                                                                                                         withProductID: product.productId)
                                                                        case .failure(let error):
                                                                            self.output?.processComplete(wasSuccessful: false,
                                                                                                         withMessage: error?.localizedFailureReason ?? iDooh.kGenericErrorMessage,
                                                                                                         withProductID: nil)
                                                                        }
                                        })
                                    case .failure(let error):
                                        self.output?.processComplete(wasSuccessful: false,
                                                                     withMessage: error?.localizedFailureReason ?? iDooh.kGenericErrorMessage,
                                                                     withProductID: nil)
                                    }
                })
                
//                self.webservice?.GET(iDooh.kWSProductsMagento(),
//                                     parameters: nil,
//                                     block: { response in
//                                        switch response {
//                                        case .success(let valueProduct):
//                                            let product = Product.init(dictionary: valueProduct?.first as! [String: Any])
//                                            // Add Product to Manager
//                                            self.manager?.createProduct(withProduct: product,
//                                                                        WithUser: self.session?.getUserSessionAsUser(),
//                                                                        withCompletionBlock: { response in
//                                                                            switch response {
//                                                                            case .success(_):
//                                                                                self.output?.processComplete(wasSuccessful: true,
//                                                                                                             withMessage: "Product Succesfully Added!",
//                                                                                                             withProductID: product.productId)
//                                                                            case .failure(let error):
//                                                                                self.output?.processComplete(wasSuccessful: false,
//                                                                                                             withMessage: error?.localizedFailureReason ?? iDooh.kGenericErrorMessage,
//                                                                                                             withProductID: nil)
//                                                                            }
//                                            })
//                                        case .failure(let error):
//                                            self.output?.processComplete(wasSuccessful: false,
//                                                                         withMessage: error?.localizedFailureReason ?? iDooh.kGenericErrorMessage,
//                                                                         withProductID: nil)
//                                        }
//                })
            }
        })
    }
    
    // MARK: Privates
    // TODO: Needs to update again once qr code is good
    func serviceParameterFromQRDecode(_ qrString: String) -> String {
        return qrString
    }
}
