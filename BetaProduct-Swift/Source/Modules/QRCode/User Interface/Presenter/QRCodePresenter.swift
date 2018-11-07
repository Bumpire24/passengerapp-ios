//
//  QRCodePresenter.swift
//  BetaProduct-Swift
//
//  Created by User on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodePresenter: NSObject, QRCodeInteractorOutput, QRCodeModuleProtocol, AVCaptureMetadataOutputObjectsDelegate {
    var interactor: QRCodeInteractorInput?
    var wireframe: QRCodeWireframe?
    var view: QRCodeViewProtocol?
    
    // For Simulations only
    func saveARandomProduct() {
        let dice = arc4random_uniform(30) + 1
        interactor?.processQRCodeAndFindProduct(String(dice))
    }
    
    // MARK: QRCodeModuleProtocol
    func calibrateCameraWithFrame(_ frame: CGRect) {
        interactor?.configureCameraWithFrame(frame)
    }
    
    // MARK: QRCodeInteractorOutput
    func processComplete(wasSuccessful isSuccess: Bool, withMessage message: String, withProductID productId: Int?) {
        view?.displayMessage(message, isSuccessful: isSuccess)
        if let nonNilProductId = productId {
            view?.showProductWithId(nonNilProductId)
        }
    }
    
    func cameraConfigurationComplete(wasSuccessful isSuccess: Bool, withMessage message: String, withCameraLayer cameraLayer: CALayer?) {
        if isSuccess {
            view?.addCameraView(cameraLayer!)
            interactor?.startCamera()
        } else {
            view?.showEmptyView()
            view?.displayMessage(message, isSuccessful: isSuccess)
        }
    }
    
    func foundMetaDataObject(_ qrObject: AVMetadataObject) {
        view?.showGreenBoxWithFrame(qrObject.bounds)
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            view?.hideGreenBox()
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            interactor?.findMetaDataObjectinCameraLayer(metadataObj)
            interactor?.stopCamera()
            interactor?.processQRCodeAndFindProduct(metadataObj.stringValue!)
        }
    }
    
    // MARK: Privates
}
