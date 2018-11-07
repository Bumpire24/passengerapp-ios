//
//  QRCodeBaseView.swift
//  BetaProduct-Swift
//
//  Created by User on 3/21/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class QRCodeBaseView: BaseView {

    override func viewDidLoad() {
        super.viewDidLoad()
        applyImageWatermark(imageNamed: "QRBackground.png")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func applyImageWatermark(imageNamed imageName : String) {
        self.view.backgroundColor = iDoohStyle.iDoohPinkMainColor
        var backgroundImageBounds = UIScreen.main.bounds
        backgroundImageBounds.origin.y = 20
        backgroundImageBounds.size.height = backgroundImageBounds.height - 20
        let backgroundImage = UIImageView(frame: backgroundImageBounds)
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = .scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
}
