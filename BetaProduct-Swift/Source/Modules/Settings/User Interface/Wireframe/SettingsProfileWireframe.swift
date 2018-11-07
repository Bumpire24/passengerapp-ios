//
//  SettingsProfileWireframe.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 12/1/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

let profileSettingsViewIdentifier = "ProfileSettingsView"

class SettingsProfileWireframe: BaseWireframe {
    var profileSettingsView : ProfileSettingsView?
    var presenter : SettingsPresenterProfile?
    private var photoUploadPicker: UIImagePickerController?
    private var view: UIViewController?
    
    func presentProfileSettingsViewFromViewController(_ viewController: UIViewController) {
        let newViewController = profileSettingsViewController()
        profileSettingsView = newViewController
        photoUploadPicker = UIImagePickerController()
        photoUploadPicker?.delegate = presenter
        profileSettingsView?.eventHandler = presenter
        presenter?.profileSettingsView  = newViewController
        view = newViewController
        viewController.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    private func profileSettingsViewController() -> ProfileSettingsView {
        let viewcontroller = mainStoryBoard().instantiateViewController(withIdentifier: profileSettingsViewIdentifier) as! ProfileSettingsView
        return viewcontroller
    }
    
    func presentCamera() {
        if let photoPicker = photoUploadPicker {
            photoPicker.sourceType = .camera
            photoPicker.allowsEditing = false
            view?.present(photoPicker, animated: true, completion: nil)
        }
    }
    
    func presentPhotoLibrary() {
        if let photoPicker = photoUploadPicker {
            photoPicker.sourceType = .photoLibrary
            photoPicker.allowsEditing = false
            view?.present(photoPicker, animated: true, completion: nil)
        }
    }
    
    func dismissPhotoUploadPicker() {
        photoUploadPicker?.dismiss(animated: true, completion: nil)
    }
}
