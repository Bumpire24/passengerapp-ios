//
//  QRCodeModuleInterface.swift
//  BetaProduct-Swift
//
//  Created by User on 1/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

protocol QRCodeModuleProtocol {
    func calibrateCameraWithFrame(_ frame: CGRect)
    func saveARandomProduct()
}
