//
//  QRCodeView.swift
//  BetaProduct-Swift
//
//  Created by Enrico Boller on 20/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class QRCodeView: QRCodeBaseView, QRCodeViewProtocol {
    @IBOutlet weak var QRScannerView: UIView!
    @IBOutlet weak var QRScannerInstructions: UILabel!
    @IBOutlet weak var QRImageBackground: UIImageView!
    
    private var qrCodeDetectView = UIView()
    var eventHandler: QRCodeModuleProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        QRImageBackground.image = UIImage(named: "QRBackground.png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventHandler?.calibrateCameraWithFrame(self.view.layer.bounds)
        eventHandler?.saveARandomProduct()
    }
    
    // MARK: Privates
    private func calibrateQRCodeDetectView() {
        qrCodeDetectView.layer.borderColor = UIColor.green.cgColor
        qrCodeDetectView.layer.borderWidth = 2
        view.addSubview(qrCodeDetectView)
        view.bringSubview(toFront: qrCodeDetectView)
    }
    
    // MARK: QRCodeViewProtocol
    func showEmptyView() {
        
    }
    
    func showGreenBoxWithFrame(_ frame: CGRect) {
        qrCodeDetectView.frame = frame
    }
    
    func hideGreenBox() {
        qrCodeDetectView.frame = CGRect.zero
    }
    
    func displayMessage(_ message: String, isSuccessful: Bool) {
        
    }
    
    func showProductWithId(_ id: Int) {
        
    }
    
    func addCameraView(_ camera: CALayer) {
        self.view.layer.addSublayer(camera)
        calibrateQRCodeDetectView()
    }
}
