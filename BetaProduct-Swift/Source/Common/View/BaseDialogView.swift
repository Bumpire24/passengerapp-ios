//
//  BaseDialogView.swift
//  BetaProduct-Swift
//
//  Created by User on 1/23/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit



enum BaseDialogButton {
    case affirmative
    case negative
}

protocol BaseDialogViewDelegate {
    func executeActionUnderClickedButton(clickedButton : BaseDialogButton)
}

class BaseDialogView: UIViewController {
    
    ///MARK: - Components
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var titleAndMessageView: UIView!
    @IBOutlet weak var messageTitle: IDoohHeaderLabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var messageContent: IDoohInstructionLabel!
    @IBOutlet weak var negativeButton: IDoohDialogTertiaryButton!
    @IBOutlet weak var affirmativeButton: IDoohDialogPrimaryButton!
    @IBOutlet weak var messageStatusBackgroundImage: UIImageView!
    
    ///MARK: - Properties
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
    
    var currentView : UIViewController?
    var clickedButton : BaseDialogButton?
    var delegate: BaseDialogViewDelegate?
    
    ///MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    ///MARK: - Shared Properties
    
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
        currentView = viewController
        populateMessageBox(messageProperties: messageProperties)
        
        guard messageStatus != nil else {
            return
        }
        
        let messageStatusBackground = messageStatus! ? "checkMarkAssocBackground" : "errorAssocBackground"
        applyThemeBasedOnMessageStatus(messageStatusBackground: messageStatusBackground)
    }
    
    ///MARK: - Helper Methods
    
    fileprivate func discardMessageView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func populateMessageBox(messageProperties: Dictionary<String, String>) {
        messageTitleText = messageProperties["title"]!
        messageContentText = messageProperties["message"]!
        affirmativeButtonText = messageProperties["affirmativeButtonLabel"]!
        
        guard messageProperties["negativeButtonLabel"] != nil else {
            negativeButton.isHidden = true
            return
        }
        
        negativeButtonText = messageProperties["negativeButtonLabel"]!
    }
    
    fileprivate func applyThemeBasedOnMessageStatus(messageStatusBackground: String) {
        self.messageStatusBackgroundImage.image = UIImage(named: messageStatusBackground)
    }
    
    ///MARK: - Action Methods
    @IBAction func affirmationAction(_ sender: Any) {
        clickedButton = BaseDialogButton.affirmative
        discardMessageView()
        self.delegate?.executeActionUnderClickedButton(clickedButton: .affirmative)
    }
    
    @IBAction func negationAction(_ sender: Any) {
        clickedButton = BaseDialogButton.negative
        discardMessageView()
        self.delegate?.executeActionUnderClickedButton(clickedButton: .negative)
    }

}
