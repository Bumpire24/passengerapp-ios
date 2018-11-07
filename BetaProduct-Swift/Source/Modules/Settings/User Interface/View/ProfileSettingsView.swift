//
//  ProfileSettingsView.swift
//  BetaProduct-Swift
//
//  Created by User on 11/28/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ProfileSettingsView: BaseView, SettingsProfileViewProtocol, UITextViewDelegate {

    @IBOutlet weak var profileImage: IDoohProfileImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var firstNameView: IDoohRoundedContainerView!
    @IBOutlet weak var firstNameImage: UIImageView!
    @IBOutlet weak var firstNameField: IDoohRoundedContainerTextField!
    @IBOutlet weak var firstNameButton: UIButton!
    @IBOutlet weak var middleNameView: IDoohRoundedContainerView!
    @IBOutlet weak var middleNameImage: UIImageView!
    @IBOutlet weak var middleNameField: IDoohRoundedContainerTextField!
    @IBOutlet weak var middleNameButton: UIButton!
    @IBOutlet weak var lastNameView: IDoohRoundedContainerView!
    @IBOutlet weak var lastNameImage: UIImageView!
    @IBOutlet weak var lastNameField: IDoohRoundedContainerTextField!
    @IBOutlet weak var lastNameButton: UIButton!
    @IBOutlet weak var billingAddressView: IDoohRoundedContainerView!
    @IBOutlet weak var billingAddressImage: UIImageView!
    @IBOutlet weak var billingAddressFieldArea: IDoohRoundedContainerTextView!
    @IBOutlet weak var billingAddressButton: UIButton!
    @IBOutlet weak var saveProfileButton: IDoohPrimaryButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var cancelProfileButton: IDoohSecondaryButton!
    @IBOutlet weak var profileVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var floatingButtonsView: UIView!
    
    var eventHandler : SettingsProfileModuleProtocol?
    var displayItem = SettingsProfileDisplayItem()
    var newDisplayImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modifyTextViewProperty()
        displayProfileInformation()
        defineUIControlDefaultState()
        populateButtons()
        enableTapGesture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI State functions
    
    func defineUIControlDefaultState() {
        saveProfileButton.isHidden = true
        cancelProfileButton.isHidden = true
        orLabel.isHidden = true
        firstNameField.isEnabled = false
        firstNameButton.isEnabled = true
        middleNameField.isEnabled = false
        middleNameButton.isEnabled = true
        lastNameField.isEnabled = false
        lastNameButton.isEnabled = true
        billingAddressFieldArea.isEditable = false
        billingAddressFieldArea.specifyPlaceHolderText(placeHolder: "shipping address")
        billingAddressButton.isEnabled = true
        profileButton.isEnabled = true
    }
    
    func defineUIControlState(shouldEnable: Bool, forField: UIControl, withAssociatedEditButton: UIButton) {
        forField.isEnabled = shouldEnable
        withAssociatedEditButton.isEnabled = !shouldEnable
    }
    
    func defineButtonsVisibility(visibilityState: Bool) {
        saveProfileButton.isHidden = visibilityState
        cancelProfileButton.isHidden = visibilityState
        orLabel.isHidden = visibilityState
    }
    
    //MARK: IBOutlet functions
    @IBAction func editProfileImage(_ sender: Any) {
        floatingButtonsView.isHidden = false
    }
    
    @IBAction func editFirstName(_ sender: Any) {
        defineUIControlState(shouldEnable: true, forField: firstNameField, withAssociatedEditButton: firstNameButton)
        defineButtonsVisibility(visibilityState: false)
        super.specifyFirstResponder(buttonControl:  firstNameField)
    }
    
    @IBAction func editMiddleName(_ sender: Any) {
        defineUIControlState(shouldEnable: true, forField: middleNameField, withAssociatedEditButton: middleNameButton)
        defineButtonsVisibility(visibilityState: false)
        super.specifyFirstResponder(buttonControl:  middleNameField)
    }
    
    @IBAction func editLastName(_ sender: Any) {
        defineUIControlState(shouldEnable: true, forField: lastNameField, withAssociatedEditButton: lastNameButton)
        defineButtonsVisibility(visibilityState: false)
        super.specifyFirstResponder(buttonControl:  lastNameField)
    }
    
    @IBAction func editBillingAddress(_ sender: Any) {
        billingAddressFieldArea.isEditable = true
        billingAddressButton.isEnabled = false
        defineButtonsVisibility(visibilityState: false)
        billingAddressFieldArea.becomeFirstResponder()
    }
    
    @IBAction func saveProfileChanges(_ sender: Any) {
        displayItem.firstName = firstNameField.text
        displayItem.middleName = middleNameField.text
        displayItem.lastName = lastNameField.text
        displayItem.addressShipping = billingAddressFieldArea.text
        if let imageToUpdate = newDisplayImage {
            displayItem.profileImage.image = imageToUpdate
        }
        eventHandler?.saveUpdates(withItem: displayItem)
        defineUIControlDefaultState()
    }
    
    @IBAction func revertProfileChanges(_ sender: Any) {
        displayProfileInformation()
        defineUIControlDefaultState()
    }
    
    @IBAction func displayCameraScreen(_ sender: Any) {
        eventHandler?.proceedToCamera()
        floatingButtonsView.isHidden = true
    }
    
    @IBAction func displayPhotoLibrary(_ sender: Any) {
        eventHandler?.proceedToPhotoLibrary()
        floatingButtonsView.isHidden = true
    }
    
    @IBAction func closeFloatingButtonView(_ sender: Any) {
        floatingButtonsView.isHidden = true
    }
    
    ///MARK: TextView Delegate Methods
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        if billingAddressFieldArea.placeHolder.isHidden == false
        {
            moveCursorToStart(aTextView: textView)
        }
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        if billingAddressFieldArea.placeHolder.isHidden == true && billingAddressFieldArea.text == ""
        {
            billingAddressFieldArea.placeHolder.isHidden = false
        }
        
        return true
    }
    
    func moveCursorToStart(aTextView: UITextView)
    {
        DispatchQueue.main.async {
            self.applyNonPlaceholderStyle()
            aTextView.selectedRange = NSMakeRange(0, 0);
        }
    }
    
    func applyNonPlaceholderStyle()
    {
        billingAddressFieldArea.placeHolder.isHidden = true
    }
    
    //MARK: Fetching functions
    func displayProfileInformation() {
        eventHandler?.updateView()
    }
    
    func modifyTextViewProperty() {
        billingAddressFieldArea.delegate = self
        billingAddressFieldArea.layer.borderColor = iDoohStyle.iDoohClearBackground.cgColor
        billingAddressFieldArea.layer.borderWidth = 0.25
        billingAddressFieldArea.layer.cornerRadius = 0.0
    }
                                             
    func populateUserProfile(displayItems: SettingsProfileDisplayItem) {
        displayItem = displayItems
        firstNameField.text = displayItem.firstName
        middleNameField.text = displayItem.middleName
        lastNameField.text = displayItem.lastName
        let profileImageTuple = displayItem.profileImage
        
        if(!(profileImageTuple.url?.isEmpty)!) {
            UIImage().createAlamofireImage(withURLString: profileImageTuple.url!, completionClosure: ({(imageReturned) in
                self.profileImage.image =  imageReturned
            }))
        } else if (profileImageTuple.image != nil) {
            profileImage.image = profileImageTuple.image
        } else {
            profileImage.image = UIImage(named: "profile.png")
            profileImage.tintColor = iDoohStyle.iDoohProfileImageTintColor
        }
        
        guard (displayItem.addressShipping?.isEmpty)! else {
            billingAddressFieldArea.text = displayItem.addressShipping
            billingAddressFieldArea.placeHolder.isHidden = true
            return
        }
        
        billingAddressFieldArea.placeHolder.isHidden = false
    }
    
    func populateButtons() {
        self.saveProfileButton.setTitle("Save", for: .normal)
        self.saveProfileButton.titleLabel?.textColor = iDoohStyle.iDoohButtonFontColor
        self.cancelProfileButton.setTitle("Cancel", for: .normal)
    }
    
    func displayMessage(_ message : String, isSuccessful : Bool) {
        super.displayDialogMessage(withTitle: "Settings",
                                   messageContent: message,
                                   affirmativeButtonCaption: "OK",
                                   currentViewController: self,
                                   messageStatus: isSuccessful)
    }

    func updateViewWithNewProfileImage(image: UIImage) {
        profileImage.image = image
        profileImage.contentMode = .scaleAspectFill
        newDisplayImage = image
        defineButtonsVisibility(visibilityState: false)
    }
}
