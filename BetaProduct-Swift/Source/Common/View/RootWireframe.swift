//
//  RootWireframe.swift
//  BetaProduct-Swift
//
//  Created by User on 11/7/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

/// class wireframe for root module
class RootWireframe: NSObject {

    /**
     installs root view controller to app window
     - Parameters:
         - viewcontroller: root view controller
         - window: appdelegate window
     */
    func showRootViewController (rootViewController viewcontroller : UIViewController, inWindow window : UIWindow) {
        let navigationController = navigationControllerfromWindow(window)
        navigationController.viewControllers = [viewcontroller]
    }
    
    /**
     calls root view controller
     - Parameters:
        - window: appdelegate window
     - Returns: returns root view controller
     */
    private func navigationControllerfromWindow (_ window : UIWindow) -> UINavigationController {
        let navigationController = window.rootViewController as! UINavigationController
        return navigationController
    }
}
