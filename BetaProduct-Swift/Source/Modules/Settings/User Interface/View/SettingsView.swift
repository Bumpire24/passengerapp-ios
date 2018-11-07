//
//  SettingsView.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/27/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class SettingsView: BaseView {

    @IBOutlet weak var userSettingsHeader: IDoohHeaderLabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLabel: IDoohSettingsLabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var changeEmailView: UIView!
    @IBOutlet weak var emailView: UIImageView!
    @IBOutlet weak var changeEmailLabel: IDoohSettingsLabel!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var changePasswordImage: UIImageView!
    @IBOutlet weak var changePasswordLabel: IDoohSettingsLabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutImage: UIImageView!
    @IBOutlet weak var logoutLabel: IDoohSettingsLabel!
    @IBOutlet weak var logoutButton: UIButton!
    var eventHandler : SettingsHomeModuleProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UIButton Actions
    
    @IBAction func displayUserProfile(_ sender: Any) {
        eventHandler?.proceedToProfileSettings()
    }
    
    @IBAction func displayChangeEmailView(_ sender: Any) {
        eventHandler?.proceedToEmailSettings()
    }
    
    @IBAction func displayChangePasswordView(_ sender: Any) {
        eventHandler?.proceedToPaswordSettings()
    }
    
    @IBAction func logOutUser(_ sender: Any) {
        eventHandler?.logout()
    }
}
