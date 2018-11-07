//
//  BaseView.swift
//  BetaProduct-Swift
//
//  Created by User on 11/10/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

let baseDialogViewIdentifier = "BaseDialogView"

class BaseView: UIViewController, BaseDialogViewDelegate {
    typealias ActionClosure = () -> ()
    var successAction: ActionClosure?
    var failureAction: ActionClosure?
    var baseMessageView: BaseDialogView?
    
    //MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instantiateBaseMessageView()
        applyImageWatermark()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applyGradientBackground() {
        let gradientView = UIView(frame: self.view.bounds)
        var gradientLayer: CAGradientLayer!
        
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [iDoohStyle.iDoohGradientColor1.cgColor, iDoohStyle.iDoohGradientColor2.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        self.view.insertSubview(gradientView, at: 0)
    }
    
    func applyImageWatermark() {
        self.view.backgroundColor = iDoohStyle.iDoohPinkMainColor
//        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        var backgroundImageBounds = UIScreen.main.bounds
        backgroundImageBounds.origin.y = 20
        backgroundImageBounds.size.height = backgroundImageBounds.height - 20
        let backgroundImage = UIImageView(frame: backgroundImageBounds)
        backgroundImage.image = UIImage(named: "loginWatermarkImage.png")
        backgroundImage.contentMode = .scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func applyImageWatermark(imageNamed imageName : String) {
        self.view.backgroundColor = iDoohStyle.iDoohPinkMainColor
        var backgroundImageBounds = UIScreen.main.bounds
        backgroundImageBounds.origin.y = 20
        backgroundImageBounds.size.height = backgroundImageBounds.height - 20
        let backgroundImage = UIImageView(frame: backgroundImageBounds)
        backgroundImage.image = UIImage(named: imageName)
        backgroundImage.contentMode = .scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func instantiateBaseMessageView() {
        baseMessageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: baseDialogViewIdentifier) as? BaseDialogView
    }
    
    func displayDialogMessage(withTitle: String,
                              messageContent: String,
                              negativeButtonCaption: String? = "",
                              affirmativeButtonCaption: String,
                              currentViewController: UIViewController,
                              messageStatus: Bool) {
        displayDialogMessage(withTitle: withTitle, messageContent: messageContent, affirmativeButtonCaption: affirmativeButtonCaption, currentViewController: currentViewController, messageStatus: messageStatus, successCompletion: {}, failureCompletion: {})
    }
    
    func displayDialogMessage(withTitle: String,
                              messageContent: String,
                              negativeButtonCaption: String? = "",
                              affirmativeButtonCaption: String,
                              currentViewController: UIViewController,
                              messageStatus: Bool, successCompletion: @escaping () -> Void, failureCompletion: @escaping () -> Void) {
        successAction = successCompletion
        failureAction = failureCompletion
        self.present(baseMessageView!, animated: false, completion: nil)
        baseMessageView?.delegate = self
        baseMessageView?.displayMessage(title: withTitle, message: messageContent, negativeButtonCaption: negativeButtonCaption, affirmativeButtonCaption: affirmativeButtonCaption, viewController: currentViewController, messageStatus: messageStatus)
    }
    
    func specifyFirstResponder(buttonControl : IDoohRoundedContainerTextField) {
        buttonControl.becomeFirstResponder()
    }
    
    func enableTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    ///MARK: Base Message View Delegate Methods
    func executeActionUnderClickedButton(clickedButton: BaseDialogButton) {
        guard clickedButton == .affirmative else {
            failureAction?()
            return
        }
        
        successAction?()
    }
}
