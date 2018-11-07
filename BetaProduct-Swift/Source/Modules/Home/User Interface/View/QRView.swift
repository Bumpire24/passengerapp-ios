//
//  QRView.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/21/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class QRView: BaseView {

    @IBOutlet weak var QRScannerView: UIView!
    @IBOutlet weak var QRScannerInstructions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
