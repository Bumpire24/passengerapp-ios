//
//  FloatingSettingsView.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 12/5/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class FloatingSettingsView: BaseView {
    let floatingSettingsViewIdentifier = "floatingSettingsView"
    weak var currentView : UIViewController?
    @IBOutlet weak var settingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attachFloatingSettingsButtonToViewController(viewController: UIViewController) {
        let floatingSettingsButton = self.storyboard?.instantiateViewController(withIdentifier: floatingSettingsViewIdentifier) as! FloatingSettingsView
        currentView = viewController
        currentView?.addChildViewController(floatingSettingsButton)
        currentView?.view.addSubview(floatingSettingsButton.view)
    }
    
    @IBAction func displaySettings(_ sender: Any) {
        
    }
    
    
}
