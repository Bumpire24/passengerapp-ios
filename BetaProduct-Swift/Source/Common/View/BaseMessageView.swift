//
//  BaseMessageView.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/17/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

enum BaseMessageButton {
    case affirmative
    case negative
}

protocol BaseMessageViewDelegate: class {
    func executeActionUnderClickedButton(clickedButton : BaseMessageButton)
}

class BaseMessageView: UIViewController {
    let baseMessageViewIdentifier = "BaseMessageView"

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var titleAndMessageView: UIView!
    @IBOutlet weak var messageTitle: IDoohHeaderLabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var messageContent: IDoohInstructionLabel!
    @IBOutlet weak var negativeButton: IDoohDialogTertiaryButton!
    @IBOutlet weak var affirmativeButton: IDoohDialogPrimaryButton!
    @IBOutlet weak var messageStatusBackgroundImage: UIImageView!
    
    weak var currentView : UIViewController?
    weak var delegate: BaseMessageViewDelegate?
    
    var clickedButton : BaseMessageButton?
    
    var messageTitleText : String {
        get {
            return messageTitle.text ?? ""
        }
        set(messageTitleString) {
            messageTitle?.text = messageTitleString
        }
    }
    
    var messageContentText : String {
        get {
            return messageContent.text ?? ""
        }
        set(messageContentString) {
            messageContent?.text = messageContentString
        }
    }
    
    var negativeButtonText : String {
        get {
            return negativeButton.titleLabel?.text ?? ""
        }
        set(negativeButtonCaption) {
            negativeButton?.setTitle(negativeButtonCaption, for: .normal)
        }
    }
    
    var affirmativeButtonText : String {
        get {
            return affirmativeButton.titleLabel?.text ?? ""
        }
        set(affirmativeButtonCaption) {
            affirmativeButton?.setTitle(affirmativeButtonCaption, for: .normal)
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayMessage (title : String,
                         message : String,
                         negativeButtonCaption : String? = "",
                         affirmativeButtonCaption : String? = "", viewController : UIViewController, messageStatus : Bool? = nil) {
        
        
        var messageProperties : Dictionary<String, String> = ["title": title,
                                                              "message": message,
                                                              "affirmativeButtonLabel": affirmativeButtonCaption!]
        if(negativeButtonCaption?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0) {
            messageProperties["negativeButtonLabel"] = negativeButtonCaption!
        }
        
//        let messageViewController = viewController.storyboard?.instantiateViewController(withIdentifier: baseMessageViewIdentifier) as! BaseMessageView
//        currentView = viewController
//        currentView?.addChildViewController(messageViewController)
//        currentView?.view.addSubview(messageViewController.view)
        currentView = viewController
        currentView?.addChildViewController(self)
        currentView?.view.addSubview(self.view)
        populateMessageBox(messageView: self, messageProperties: messageProperties)
        
        guard messageStatus != nil else {
            return
        }
        
        let messageStatusBackground = messageStatus! ? "checkMarkAssocBackground" : "errorAssocBackground"
        applyThemeBasedOnMessageStatus(messageView: self, messageStatusBackground: messageStatusBackground)
    }
    
    @IBAction func affirmationAction(_ sender: Any) {
        self.clickedButton = BaseMessageButton.affirmative
        discardMessageView()
        self.delegate?.executeActionUnderClickedButton(clickedButton: .affirmative)
    }
    
    @IBAction func negationAction(_ sender: Any) {
        self.clickedButton = BaseMessageButton.negative
        discardMessageView()
        self.delegate?.executeActionUnderClickedButton(clickedButton: .negative)
    }
    
    func discardMessageView() {
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
    }
    
    func populateMessageBox(messageView: BaseMessageView, messageProperties: Dictionary<String, String>) {
        messageView.messageTitleText = messageProperties["title"]!
        messageView.messageContentText = messageProperties["message"]!
        messageView.affirmativeButtonText = messageProperties["affirmativeButtonLabel"]!
        
        guard messageProperties["negativeButtonLabel"] != nil else {
            messageView.negativeButton.isHidden = true
            return
        }
        
        messageView.negativeButtonText = messageProperties["negativeButtonLabel"]!
    }
    
    func applyThemeBasedOnMessageStatus(messageView: BaseMessageView, messageStatusBackground: String) {
        messageView.messageStatusBackgroundImage.image = UIImage(named: messageStatusBackground)
    }
}
