//
//  SettingsPresenterProfile.swift
//  BetaProduct-Swift
//
//  Created by User on 11/28/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

/// presenter class for module `Settings`
class SettingsPresenterProfile: NSObject, SettingsProfileModuleProtocol, SettingsProfileInteractorOutput, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// variable for interactor
    var interactor: SettingsInteractorInput?
    /// variable for wireframe
    var profileSettingsWireframe : SettingsProfileWireframe?
    /// variable for view
    var profileSettingsView: SettingsProfileViewProtocol?
    
    // MARK: SettingsProfileInteractorOutput
    /// implements protocol. see `SettingsInteractorIO.swift`
    func gotDisplayItem<T>(_ item: T) where T : SettingsDisplayItemProtocol {
        //Convert to SettingsDisplay
        let settingsProfileDisplayItem = item as! SettingsProfileDisplayItem
        profileSettingsView?.populateUserProfile(displayItems: settingsProfileDisplayItem)
    }
    
    /// implements protocol. see `SettingsInteractorIO.swift`
    func settingsUpdationComplete(wasSuccessful isSuccess: Bool,
                                  withMessage message: String,
                                  withNewDisplayItem displayItem: SettingsProfileDisplayItem) {
        profileSettingsView?.displayMessage(message, isSuccessful: isSuccess)
    }
    
    // MARK: SettingsUpdateModuleProtocol
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func saveUpdates<T>(withItem item: T) where T : SettingsDisplayItemProtocol {
        self.interactor?.validateAndUpdateSettings(usingDisplayitem: item)
    }
    
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func cancelUpdates() {
        self.interactor?.getDisplayItemForProfile()
    }
    
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func updateView() {
        self.interactor?.getDisplayItemForProfile()
    }
    
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func proceedToCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            profileSettingsWireframe?.presentCamera()
        } else {
            profileSettingsView?.displayMessage("Camera Access is needed for Photo Upload", isSuccessful: false)
        }
    }
    
    /// implements protocol. see `SettingsModuleProtocols.swift`
    func proceedToPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            profileSettingsWireframe?.presentPhotoLibrary()
        } else {
            profileSettingsView?.displayMessage("Photo Library Access is needed for Photo Upload", isSuccessful: false)
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        profileSettingsWireframe?.dismissPhotoUploadPicker()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // call wireframe to go back to profile and load image selected
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileSettingsView?.updateViewWithNewProfileImage(image: image)
        profileSettingsWireframe?.dismissPhotoUploadPicker()
    }
}
