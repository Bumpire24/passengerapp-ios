//
//  HomePresenter.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/29/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class HomeModulePresenter: NSObject, HomeModuleProtocol {
    var homeWireframe : HomeWireframe?
    
    func updateView() {
        
    }
    
    func hideTabBar() {
        
    }
    
    func showTabBar() {
        
    }
    
    func showSettingsView() {
        homeWireframe?.presentSettingsView()
    }

}
