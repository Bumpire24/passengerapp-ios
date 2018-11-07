//
//  QRCodeViewProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

protocol QRCodeViewProtocol {
    func showEmptyView()
    func showGreenBoxWithFrame(_ frame: CGRect)
    func hideGreenBox()
    func displayMessage(_ message: String, isSuccessful: Bool)
    func showProductWithId(_ id: Int)
    func addCameraView(_ camera: CALayer)
}
