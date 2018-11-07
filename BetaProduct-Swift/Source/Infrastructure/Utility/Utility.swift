//
//  Utility.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/16/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

/// class for Utilities / Helper
class Utility: NSObject {
    /**
     swaps function implementations during runtime
     - Parameters:
         - className: class name
         - origMethod: old method to be swapped
         - newMethod: new method target
     */
    static func methodSwizzleForClass(_ className : AnyClass, withOriginalMethod origMethod : Selector, replaceWithMethod newMethod : Selector) {
        let oldMethod = class_getInstanceMethod(className, origMethod)
        let newMethod = class_getInstanceMethod(className, newMethod)
    
        if (class_addMethod(className, origMethod, method_getImplementation(newMethod!), method_getTypeEncoding(newMethod!))) {
            class_replaceMethod(className, origMethod, method_getImplementation(newMethod!), method_getTypeEncoding(newMethod!))
        } else {
            method_exchangeImplementations(oldMethod!, newMethod!)
        }
    }
}
