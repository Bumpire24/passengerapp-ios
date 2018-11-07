//
//  Button+Theme.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit

let blurViewTag = 1314

extension UIButton {
    
    func subscribeToBlurringBackground() {
        self.addTarget(self, action: #selector(onButtonRelease), for: .touchUpInside)
        self.addTarget(self, action: #selector(onButtonPressDown), for: .touchDown)
    }
    
    @objc func onButtonPressDown() {
        setupBlurBackgroundEffect()
    }
    
    @objc func onButtonRelease() {
        self.viewWithTag(blurViewTag)?.removeFromSuperview()
    }
    
    func setupBlurBackgroundEffect() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = self.bounds
        blur.layer.cornerRadius = 10.0
        blur.isUserInteractionEnabled = false
        blur.tag = blurViewTag
        self.insertSubview(blur, at: 0)
    }
}
