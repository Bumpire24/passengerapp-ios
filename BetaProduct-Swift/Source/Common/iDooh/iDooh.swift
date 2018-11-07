//
//  BetaProduct.swift
//  BetaProduct-Swift
//
//  Created by User on 11/7/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit

struct iDoohStyle {
    fileprivate struct Colors {
        static var iDoohPink = UIColor(red:1.00, green:0.62, blue:0.72, alpha:1.0)
        static var iDoohDarkPink = UIColor(red:0.99, green:0.50, blue:0.84, alpha:1.0)
        static var iDoohPurple = UIColor(red:0.25, green:0.31, blue:0.49, alpha:1.0)
        static var iDoohLightGrey = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
        static var iDoohLinkBlue = UIColor(red:0.00, green:0.52, blue:0.98, alpha:1.0)
        static var iDoohWhite = UIColor.white
        static var iDoohWhiteWithOpacity60 = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        static var iDoohPurpleWithOpacity80 = UIColor(red:0.25, green:0.31, blue:0.49, alpha:0.8)
        static var iDoohPinkWithOpacity80 = UIColor(red:1.00, green:0.62, blue:0.72, alpha:0.8)
        static var iDoohLightGreyWithOpacity80 = UIColor(red:0.72, green:0.72, blue:0.72, alpha:0.8)
        static var iDoohGreen = UIColor(red:0.00, green:0.37, blue:0.09, alpha:1.0)
        static var iDoohShadowColor = UIColor(red:0.39, green:0.0, blue:0.0, alpha:1.0)
        static var iDoohClearColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.0)
    }
    
    struct Fonts {
        static var iDoohButtonLabelFont = UIFont(name: "BloggerSans-Medium", size: 20)
        static var iDoohButtonLinkFont = UIFont(name: "BloggerSans-Medium", size: 20)
        static var iDoohTextfieldFont = UIFont(name: "BloggerSans-BoldItalic", size: 15)
        static var iDoohHeaderLabelFont = UIFont(name: "BloggerSans-Bold", size: 30)
        static var iDoohInstructionLabelFont = UIFont(name: "BloggerSans-LightItalic", size: 20)
        static var iDoohSettingsLabelFont = UIFont(name: "BloggerSans-Bold", size: 20)
        static var iDoohProductNameLabelFont = UIFont(name: "BloggerSans-Bold", size: 30)
        static var iDoohProductDescriptionLabelFont = UIFont(name: "BloggerSans-BoldItalic", size: 15)
        static var iDoohOrderHistoryHeaderLabelFont = UIFont(name: "BloggerSans-Bold", size: 20)
        static var iDoohOrderHistoryFooterLabelFont = UIFont(name: "BloggerSans-LightItalic", size: 20)
    }
    
    static var iDoohLinkColor = iDoohStyle.Colors.iDoohLinkBlue
    static var iDoohLinkButtonBackgroundColor = iDoohStyle.Colors.iDoohClearColor
    static var iDoohPageViewIndicatorTintColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohCurrentPageViewIndicatorTintColor = iDoohStyle.Colors.iDoohLinkBlue
    static var iDoohProfileImageTintColor = iDoohStyle.Colors.iDoohWhite
    static var iDoohClearBackground = iDoohStyle.Colors.iDoohClearColor
    static var iDoohRoundedPositiveButtonContainerBorderColor = iDoohStyle.Colors.iDoohPink
    static var iDoohRoundedPositiveButtonContainerBackgroundColor = iDoohStyle.Colors.iDoohPurpleWithOpacity80
    static var iDoohRoundedNegativeButtonContainerBorderColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohRoundedNegativeButtonContainerBackgroundColor = iDoohStyle.Colors.iDoohLightGreyWithOpacity80
    static var iDoohRoundedTextFieldContainerBorderColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohRoundedTextFieldContainerBackgroundColor = iDoohStyle.Colors.iDoohWhiteWithOpacity60
    static var iDoohRoundedContainerTextFieldFontColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohRoundedContainerTextFieldBorderColor = iDoohStyle.Colors.iDoohClearColor
    static var iDoohRoundedContainerTextFieldBackgroundColor = iDoohStyle.Colors.iDoohClearColor
    static var iDoohTableViewHeaderCellsBackgroundColor = iDoohStyle.Colors.iDoohPinkWithOpacity80
    static var iDoohTableViewContentCellsBackgroundColor = iDoohStyle.Colors.iDoohPurpleWithOpacity80
    
    static var iDoohRoundedContainerTextViewFontColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohRoundedContainerTextViewBorderColor = iDoohStyle.Colors.iDoohClearColor
    static var iDoohRoundedContainerTextViewBackgroundColor = iDoohStyle.Colors.iDoohClearColor
    
    static var iDoohProfileImageViewBorderColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohProfileEditButtonColor = iDoohStyle.Colors.iDoohGreen
    
    static var iDoohMessageViewBorderColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohMessageViewShadowColor = iDoohStyle.Colors.iDoohShadowColor
    static var iDoohGradientColor1 = iDoohStyle.Colors.iDoohPink
    static var iDoohGradientColor2 = iDoohStyle.Colors.iDoohPurple
    static var iDoohPinkMainColor = iDoohStyle.Colors.iDoohPink
    static var iDoohPurpleMainColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohPurpleWithOpacity80 = iDoohStyle.Colors.iDoohPurpleWithOpacity80
    static var iDoohSettingsLabelFontColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohLabelFontColor = iDoohStyle.Colors.iDoohWhite
    static var iDoohHeaderLabelFontColor = iDoohStyle.Colors.iDoohWhite
    static var iDoohInstructionsLabelFontColor = iDoohStyle.Colors.iDoohWhite
    static var iDoohTextFieldFontColor = iDoohStyle.Colors.iDoohWhite
    static var iDoohTextFieldBorderColor = iDoohStyle.Colors.iDoohWhite
    static var iDoohPrimaryButtonFontColor = iDoohStyle.Colors.iDoohPink
    static var iDoohButtonFontColor = iDoohStyle.Colors.iDoohWhite
    static var iDoohPrimaryButtonBackgroundColor = iDoohStyle.Colors.iDoohPurpleWithOpacity80
    static var iDoohPrimaryButtonBorderColor = iDoohStyle.Colors.iDoohPink
    static var iDoohSecondaryButtonFontColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohSecondaryButtonBackgroundColor = iDoohStyle.Colors.iDoohPinkWithOpacity80
    static var iDoohSecondaryButtonBorderColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohTertiaryButtonFontColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohTertiaryButtonBackgroundColor = iDoohStyle.Colors.iDoohLightGreyWithOpacity80
    static var iDoohTertiaryButtonBorderColor = iDoohStyle.Colors.iDoohWhite
    static var iDoohLinkButtonFontColor = iDoohStyle.Colors.iDoohPink
    static var iDoohProductNameFontColor = iDoohStyle.Colors.iDoohPink
    static var iDoohProductDescriptionFontColor = iDoohStyle.Colors.iDoohPurple
    static var iDoohShopCartDescriptionFontColor = iDoohStyle.Colors.iDoohWhite
    static var iDoohOrderHistoryFontColor = iDoohStyle.Colors.iDoohWhiteWithOpacity60
}

/// Struct for Constants and Configs of Project Beta
struct iDooh {
    /// const for custom Error Domain
    static let kErrorDomain : String = "iDoohErrorDomain"
    
    /// const for custom Generic Error Description
    static let kGenericErrorMessage : String = "Something went wrong"
    
    /// const for Database Name
    static let kDatabaseName : String = "iDooh.sqlite"
    
    /// const for main Webservice call. Retrieves from a plist file
    static var kWebServiceBaseURL : String {
        get {
            if let configFile = Bundle.main.infoDictionary, let url = configFile["IDOOH_CONFIG_WS_URL_MAGENTO"] {
                return url as! String
            } else {
                return "http://172.32.0.70/magento2/rest/V1/idooh/"
            }
        }
    }
    
//    static var kWebServiceBaseURL : String {
//        get {
//            if let configFile = Bundle.main.infoDictionary, let url = configFile["IDOOH_CONFIG_WS_URL"] {
//                return url as! String
//            } else {
//                return "https://test-srv.idooh.com/passenger-api/"
//            }
//        }
//    }
    
    static var kWebServiceBaseURLMagento : String {
        get {
            if let configFile = Bundle.main.infoDictionary, let url = configFile["IDOOH_CONFIG_WS_URL_MAGENTO"] {
                return url as! String
            } else {
                return "http://172.32.0.70/magento2/rest/V1/idooh/"
            }
        }
    }
    
    static var kPayURLScheme: String {
        get {
            if let configFile = Bundle.main.infoDictionary, let url = configFile["IDOOH_CONFIG_PAY_URL_SCHEME"] {
                return url as! String
            } else {
                return "com.outsourced.BetaProduct-Swift.payments"
            }
        }
    }
    
    static var kWebServicePayBaseURL : String {
        get {
            if let configFile = Bundle.main.infoDictionary, let url = configFile["IDOOH_CONFIG_WS_PAY_URL"] {
                return url as! String
            } else {
                return "http://192.168.64.2/payment/transact.php"
            }
        }
    }
    
    static func udidString() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
//        let deviceID = UUID.init(uuidString: "BF73F5D0-FD46-4478-B575-DBA6CD8A5367")
//        return (deviceID?.uuidString)!
    }
    
    /**
     webservice url construct for Session
     - Returns: url string
     */
    static func kWSSessions() -> String {
        return kWebServiceBaseURL +  "sessions/"
    }
    
    /**
     webservice url construct for Session
     - Parameters:
         - email: email string
         - password: password string
         - deviceID: device id string
     - Returns: url string
     */
    static func kWSSessions(withEmail email: String, andWithPassword password: String, andWithDeviceID deviceID: String) -> String {
        return String.init(format: "%@users/login/username/%@/password/%@/device/%@", kWebServiceBaseURLMagento, email, password, deviceID)
//        return String.init(format: "%@sessions/?grant_type=password&email=%@&password=%@&device_id=%@", kWebServiceBaseURL, email, password, deviceID)
    }
    
    /**
     webservice url construct for User
     - Returns: url string
     */
    static func kWSUsers() -> String {
        return kWebServiceBaseURL + "users/"
    }
    
    /**
     webservice url construct for User
     - Parameters:
        - id: user id string
     - Returns: url string
     */
    static func kWSUsers(withID id: String) -> String {
        return kWebServiceBaseURL + "users/" + id
    }
    
    /**
     webservice url construct for Order
     - Parameters:
         - id: user id string
         - orderid: order id string
         - Returns: url string
     */
    static func KWSUsersOrders(withID id: String, andWithOrderID orderid: String) -> String {
        return kWebServiceBaseURL + "users/" + id + "/orders/" + orderid
    }
    
    /**
     webservice url construct for Order
     - Parameters:
        - id: user id string
     - Returns: url string
     */
    static func KWSUsersOrders(withID id: String) -> String {
        return kWebServiceBaseURL + "users/" + id + "/orders/"
    }
    
    static func kWSUsersOrders(withID id: String, andWithUpdateDate date: String) -> String {
        return kWebServiceBaseURL + "users/" + id + "/orders/" + date
    }
    
    static func kWSOrdersToken() -> String {
        return kWebServiceBaseURL + "orders/token"
    }
    
    /**
     webservice url construct for Order
     - Parameters:
        - id: order id string
     - Returns: url string
     */
    static func kWSOrderItems(withID id: String) -> String {
        return kWebServiceBaseURL + "orders/" + id + "/items"
    }
    
    /**
     webservice url construct for Product
     - Returns: url string
     */
    static func kWSProducts() -> String {
        return kWebServiceBaseURL + "products/"
    }
    
    /**
     webservice url construct for Product
     - Parameters:
        - id: product id string
     - Returns: url string
     */
    static func kWSProducts(withID id: String) -> String {
        return kWebServiceBaseURL + "products/" + id
    }
    
    static func kWSUsersPassword(withID id: String) -> String {
        return kWebServiceBaseURL + "users/" + id + "/password"
    }
    
    static func kWSForgotPass() -> String {
        return kWebServiceBaseURL + "users/password"
    }
    
    static func kWSessionsMegento() -> String {
        return kWebServiceBaseURLMagento +  "rest/V1/integration/admin/token"
    }
    
    static func kWSProductsMagento() -> String {
        return kWebServiceBaseURLMagento + "rest/V1/products/Sample"
    }
    
    static let kSyncComplete: String = "SyncComplete"
}
