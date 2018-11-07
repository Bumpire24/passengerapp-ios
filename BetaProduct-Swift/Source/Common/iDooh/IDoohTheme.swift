//
//  IDoohTheme.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 11/20/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit

enum IDoohTheme: Int {
    case ThreeDimensional, NonDimensional
    
    private enum Keys {
        static let selectedTheme = "SelectedTheme"
    }
    
    static var current: IDoohTheme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.selectedTheme)
        return IDoohTheme(rawValue: storedTheme) ?? .ThreeDimensional
    }
    
    var mainColor: UIColor {
        switch self {
        case .ThreeDimensional:
            return iDoohStyle.iDoohPinkMainColor
        case .NonDimensional:
            return iDoohStyle.iDoohPurpleMainColor
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .ThreeDimensional:
            return .black
        case .NonDimensional:
            return .default
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .ThreeDimensional:
            return iDoohStyle.iDoohPinkMainColor
        case .NonDimensional:
            return iDoohStyle.iDoohPurpleMainColor
        }
    }
    
    func apply() {
        UserDefaults.standard.set(rawValue, forKey: Keys.selectedTheme)
        UserDefaults.standard.synchronize()
        
        UIApplication.shared.delegate?.window??.tintColor = mainColor
        
        UINavigationBar.appearance().barStyle = barStyle
        //UINavigationBar.appearance().setBackgroundImage(navigationBackgroundImage, for: .default)
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
        
        UITabBar.appearance().barStyle = barStyle
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = iDoohStyle.iDoohPageViewIndicatorTintColor
        appearance.currentPageIndicatorTintColor = iDoohStyle.iDoohCurrentPageViewIndicatorTintColor
        
//        UITableViewCell.appearance().backgroundColor = iDoohStyle.iDoohTableViewHeaderCellsBackgroundColor
    }
}

//MARK: UITableViewCell Classes
class iDoohTableHeaderCell : UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        changeBackgroundColor()
    }
    
    func changeBackgroundColor() {
        self.backgroundColor = iDoohStyle.iDoohTableViewHeaderCellsBackgroundColor
    }
}

class iDoohTableContentCell : UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        changeBackgroundColor()
    }
    
    func changeBackgroundColor() {
        self.backgroundColor = iDoohStyle.iDoohTableViewContentCellsBackgroundColor
    }
}

//MARK: Label Classes
class IDoohHeaderLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.font = iDoohStyle.Fonts.iDoohHeaderLabelFont
        self.textColor = iDoohStyle.iDoohHeaderLabelFontColor
    }
}

class IDoohInstructionLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.font = iDoohStyle.Fonts.iDoohInstructionLabelFont
        self.textColor = iDoohStyle.iDoohLabelFontColor
    }
}

class IDoohSettingsLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.font = iDoohStyle.Fonts.iDoohSettingsLabelFont
        self.textColor = iDoohStyle.iDoohSettingsLabelFontColor
    }
}

class IDoohProductNameLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.font = iDoohStyle.Fonts.iDoohProductNameLabelFont
        self.textColor = iDoohStyle.iDoohProductNameFontColor
    }
}

class IDoohProductDescriptionLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.font = iDoohStyle.Fonts.iDoohProductDescriptionLabelFont
        self.textColor = iDoohStyle.iDoohProductDescriptionFontColor
    }
}

class IdoohShopCartDescriptionLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.font = iDoohStyle.Fonts.iDoohProductDescriptionLabelFont
        self.textColor = iDoohStyle.iDoohShopCartDescriptionFontColor
    }
}

class IDoohOrderHistoryHeaderLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.font = iDoohStyle.Fonts.iDoohOrderHistoryHeaderLabelFont
        self.textColor = iDoohStyle.iDoohOrderHistoryFontColor
    }
}

class IDoohOrderHistoryFooterLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        self.font = iDoohStyle.Fonts.iDoohOrderHistoryFooterLabelFont
        self.textColor = iDoohStyle.iDoohOrderHistoryFontColor
    }
}

//MARK: Text Field Classes
class IDoohRoundedContainerTextField : UITextField {
    override func awakeFromNib() {
        specifyFont()
        specifyBounds()
    }
    
    func specifyFont() {
        self.font = iDoohStyle.Fonts.iDoohTextfieldFont
        self.textColor = iDoohStyle.iDoohRoundedContainerTextFieldFontColor
    }
    
    func specifyBounds() {
        self.layer.borderWidth = 0.0
        self.layer.borderColor = iDoohStyle.iDoohRoundedContainerTextFieldBorderColor.cgColor
        self.layer.backgroundColor = iDoohStyle.iDoohRoundedContainerTextFieldBackgroundColor.cgColor
    }
}

class IDoohEntryField : UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        applyUITheme()
    }
    
    func applyUITheme() {
        specifyFont()
        specifyBounds()
        
    }
    
    func specifyFont() {
        self.font = iDoohStyle.Fonts.iDoohTextfieldFont
        self.textColor = iDoohStyle.iDoohTextFieldFontColor
    }
    
    func specifyBounds() {
        self.layer.cornerRadius = 25.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = iDoohStyle.iDoohTextFieldBorderColor.cgColor
    }
}

class IDoohRoundedContainerField : IDoohEntryField {
    override func awakeFromNib() {
        super.awakeFromNib()
        super.applyUITheme()
    }
    
    override func specifyBounds() {
        self.layer.borderColor = iDoohStyle.iDoohClearBackground.cgColor
    }
}

//MARK: UIImage View Classes
class IDoohProfileImageView : UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyBounds()
    }
    
    func specifyBounds() {
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = iDoohStyle.iDoohProfileImageViewBorderColor.cgColor
    }
}

//MARK: Button Classes
class IDoohButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyFont()
        specifyBounds()
    }
    
    func specifyFont() {
        self.titleLabel?.font = iDoohStyle.Fonts.iDoohButtonLabelFont
        self.titleLabel?.textColor = iDoohStyle.iDoohButtonFontColor
    }
    
    func specifyBounds() {
        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.borderWidth = 1.0
    }
}

class IDoohFloatingPrimaryButton : IDoohButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyBorderColor()
    }
    
    func specifyBorderColor() {
        self.layer.borderColor = iDoohStyle.iDoohPrimaryButtonBackgroundColor.cgColor
        self.layer.borderWidth = 0.0
    }
}

class IDoohFloatingSecondaryButton : IDoohButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyBorderColor()
    }
    
    func specifyBorderColor() {
        self.layer.borderColor = iDoohStyle.iDoohPrimaryButtonBorderColor.cgColor
        self.layer.borderWidth = 0.0
    }
}

class IDoohPrimaryButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyFont()
        specifyBounds()
        specifyFillColor()
    }
    
    func specifyFont() {
        self.titleLabel?.font = iDoohStyle.Fonts.iDoohButtonLabelFont
        self.setTitleColor(iDoohStyle.iDoohPrimaryButtonFontColor, for: .normal)
    }
    
    func specifyBounds() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = iDoohStyle.iDoohPrimaryButtonBorderColor.cgColor
    }
    
    func specifyFillColor() {
        self.backgroundColor = iDoohStyle.iDoohPrimaryButtonBackgroundColor
    }
}

protocol IDoohDialogButton {
    func specifyButtonShadow()
}

class IDoohDialogPrimaryButton : IDoohPrimaryButton, IDoohDialogButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyButtonShadow()
    }
    
    func specifyButtonShadow() {
        specifyDialogButtonShadow(buttonControl: self)
    }
}

class IDoohSecondaryButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyFont()
        specifyBounds()
        specifyFillColor()
    }
    
    func specifyFont() {
        self.titleLabel?.font = iDoohStyle.Fonts.iDoohButtonLabelFont
        self.setTitleColor(iDoohStyle.iDoohSecondaryButtonFontColor, for: .normal)
    }
    
    func specifyBounds() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = iDoohStyle.iDoohSecondaryButtonBorderColor.cgColor
    }
    
    func specifyFillColor() {
        self.backgroundColor = iDoohStyle.iDoohSecondaryButtonBackgroundColor
    }
}

class IDoohDialogSecondaryButton : IDoohSecondaryButton, IDoohDialogButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyButtonShadow()
    }
    
    func specifyButtonShadow() {
        specifyDialogButtonShadow(buttonControl: self)
    }
}

class IDoohTertiaryButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyFont()
        specifyBounds()
        specifyFillColor()
    }
    
    func specifyFont() {
        self.titleLabel?.font = iDoohStyle.Fonts.iDoohButtonLabelFont
        self.setTitleColor(iDoohStyle.iDoohTertiaryButtonFontColor, for: .normal)
    }
    
    func specifyBounds() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = iDoohStyle.iDoohTertiaryButtonBorderColor.cgColor
    }
    
    func specifyFillColor() {
        self.backgroundColor = iDoohStyle.iDoohTertiaryButtonBackgroundColor
    }
}

class IDoohDialogTertiaryButton : IDoohTertiaryButton, IDoohDialogButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyButtonShadow()
    }
    
    func specifyButtonShadow() {
        specifyDialogButtonShadow(buttonControl: self)
    }
}

class IDoohLinkButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyFont()
        specifyFillColor()
    }
    
    func specifyFont() {
        self.titleLabel?.font = iDoohStyle.Fonts.iDoohButtonLinkFont
        self.setTitleColor(iDoohStyle.iDoohLinkButtonFontColor, for: .normal)
    }
    
    func specifyFillColor() {
        self.backgroundColor = iDoohStyle.iDoohLinkButtonBackgroundColor
    }
}

class IDoohEditButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyTint()
    }
    
    func specifyTint() {
        self.tintColor = iDoohStyle.iDoohProfileEditButtonColor
    }
}

//MARK: Container Classes
class IDoohHeaderContainer : UIView {
    override func awakeFromNib() {
        specifyContainerSpecs()
        //specifyContainerBackground()
    }
    
    func specifyContainerSpecs() {
        self.layer.borderColor = iDoohStyle.iDoohClearBackground.cgColor
        self.layer.backgroundColor = iDoohStyle.iDoohClearBackground.cgColor
    }
    
    func specifyContainerBackground() {
        let backgroundImage = UIImageView(frame: self.bounds)
        backgroundImage.image = UIImage(named: "headerLabelBackground.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.insertSubview(backgroundImage, at: 0)
        let horConstraint = NSLayoutConstraint(item: backgroundImage, attribute: .centerX, relatedBy: .equal,
                                               toItem: self, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: backgroundImage, attribute: .centerY, relatedBy: .equal,
                                               toItem: self, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        self.addConstraints([horConstraint, verConstraint])
    }
}

class IDoohInstructionsContainer : UIView {
    override func awakeFromNib() {
        specifyContainerSpecs()
        //specifyContainerBackground()
    }
    
    func specifyContainerSpecs() {
        self.layer.borderColor = iDoohStyle.iDoohClearBackground.cgColor
        self.layer.backgroundColor = iDoohStyle.iDoohClearBackground.cgColor
    }
    
    func specifyContainerBackground() {
        let backgroundImage = UIImageView(frame: self.bounds)
        backgroundImage.image = UIImage(named: "instructionsLabelBackground.png")
        backgroundImage.contentMode = .scaleAspectFill
        self.insertSubview(backgroundImage, at: 0)
        let horConstraint = NSLayoutConstraint(item: backgroundImage, attribute: .centerX, relatedBy: .equal,
                                               toItem: self, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: backgroundImage, attribute: .centerY, relatedBy: .equal,
                                               toItem: self, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        self.addConstraints([horConstraint, verConstraint])
    }
}

class IDoohRoundedTextFieldContainer: UIView {
    override func awakeFromNib() {
        specifyContainerSpecs()
    }
    
    func specifyContainerSpecs() {
        self.layer.borderColor = iDoohStyle.iDoohRoundedTextFieldContainerBorderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.backgroundColor = iDoohStyle.iDoohRoundedTextFieldContainerBackgroundColor.cgColor
        self.layer.cornerRadius = self.frame.height / 2
    }
}

class IDoohRoundedContainerView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyBorderProperty()
    }
    
    func specifyBorderProperty() {
        self.layer.borderColor = iDoohStyle.iDoohTextFieldBorderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.backgroundColor = iDoohStyle.iDoohClearBackground.cgColor
        self.layer.cornerRadius = self.frame.height / 2
    }
}

class IDoohRegularContainerView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyBorderProperty()
    }
    
    func specifyBorderProperty() {
        self.layer.borderColor = iDoohStyle.iDoohRoundedTextFieldContainerBorderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.backgroundColor = iDoohStyle.iDoohRoundedTextFieldContainerBackgroundColor.cgColor
        self.layer.cornerRadius = 0.0
    }
}

class IDoohRoundedPositiveButtonContainerView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()    
        specifyBorderProperty()
    }
    
    func specifyBorderProperty() {
        self.layer.borderColor = iDoohStyle.iDoohRoundedPositiveButtonContainerBorderColor.cgColor
        self.layer.borderWidth = 1.0
        self.layer.backgroundColor = iDoohStyle.iDoohRoundedPositiveButtonContainerBackgroundColor.cgColor
        self.layer.cornerRadius = 30.0
    }
}

class IDoohRoundedNegativeButtonContainerView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyBorderProperty()
    }
    
    func specifyBorderProperty() {
        self.layer.borderColor = iDoohStyle.iDoohRoundedNegativeButtonContainerBorderColor.cgColor
        self.layer.borderWidth = 0.0
        self.layer.backgroundColor = iDoohStyle.iDoohRoundedNegativeButtonContainerBackgroundColor.cgColor
        self.layer.cornerRadius = 30.0
    }
}

class IDoohRoundedIncrementerButtonContainerView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyBorderProperty()
    }
    
    func specifyBorderProperty() {
        self.layer.borderColor = iDoohStyle.iDoohRoundedPositiveButtonContainerBorderColor.cgColor
        self.layer.borderWidth = 0.0
        self.layer.backgroundColor = iDoohStyle.iDoohRoundedPositiveButtonContainerBackgroundColor.cgColor
        self.layer.cornerRadius = 15.0
    }
}

//MARK: Text View Classes
class IDoohRoundedContainerTextView : UITextView {
    var placeHolder : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyFont()
        specifyBorderProperty()
        specifyPlaceHolder()

    }
    
    func specifyFont() {
        self.font = iDoohStyle.Fonts.iDoohTextfieldFont
        self.textColor = iDoohStyle.iDoohRoundedContainerTextFieldFontColor
    }
    
    func specifyBorderProperty () {
        self.layer.borderColor = iDoohStyle.iDoohRoundedContainerTextViewBorderColor.cgColor
        self.layer.borderWidth = 0.0
        self.layer.backgroundColor = iDoohStyle.iDoohClearBackground.cgColor
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    func specifyPlaceHolder() {
        placeHolder = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        placeHolder.text = "shipping address"
        placeHolder.textColor = iDoohStyle.iDoohRoundedContainerTextViewFontColor
        placeHolder.font = iDoohStyle.Fonts.iDoohTextfieldFont
        placeHolder.textAlignment = .center
        self.addSubview(placeHolder)
        
        let horConstraint = NSLayoutConstraint(item: placeHolder!, attribute: .centerX, relatedBy: .equal,
                                               toItem: self, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: placeHolder!, attribute: .centerY, relatedBy: .equal,
                                               toItem: self, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        self.addConstraints([horConstraint, verConstraint])
    }
    
    func specifyPlaceHolderText(placeHolder: String) {
        self.placeHolder.text = placeHolder
    }
}

class IDoohRegularContainerTextView : UITextView {
    var placeHolder : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        specifyFont()
        specifyBorderProperty()
        specifyPlaceHolder()
        
    }
    
    func specifyFont() {
        self.font = iDoohStyle.Fonts.iDoohTextfieldFont
        self.textColor = iDoohStyle.iDoohRoundedContainerTextFieldFontColor
    }
    
    func specifyBorderProperty () {
        self.layer.borderColor = iDoohStyle.iDoohRoundedContainerTextViewBorderColor.cgColor
        self.layer.borderWidth = 0.0
        self.layer.backgroundColor = iDoohStyle.iDoohClearBackground.cgColor
        self.layer.cornerRadius = 0.0
    }
    
    func specifyPlaceHolder() {
        placeHolder = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        placeHolder.text = "shipping address"
        placeHolder.textColor = iDoohStyle.iDoohRoundedContainerTextViewFontColor
        placeHolder.font = iDoohStyle.Fonts.iDoohTextfieldFont
        placeHolder.textAlignment = .center
        self.addSubview(placeHolder)
        
        let horConstraint = NSLayoutConstraint(item: placeHolder!, attribute: .centerX, relatedBy: .equal,
                                               toItem: self, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: placeHolder!, attribute: .centerY, relatedBy: .equal,
                                               toItem: self, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        self.addConstraints([horConstraint, verConstraint])
    }
    
    func specifyPlaceHolderText(placeHolder: String) {
        self.placeHolder.text = placeHolder
    }
}



fileprivate func specifyDialogButtonShadow(buttonControl: UIButton) {
    buttonControl.layer.borderColor = iDoohStyle.iDoohClearBackground.cgColor
    buttonControl.layer.shadowColor = iDoohStyle.iDoohMessageViewShadowColor.cgColor
    buttonControl.layer.shadowOpacity = 1.0
    buttonControl.layer.shadowRadius = 3.0
    buttonControl.layer.shadowOffset = CGSize(width: 0, height: 3)
}
