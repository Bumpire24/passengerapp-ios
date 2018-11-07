
//
//  AppDependencies.swift
//  BetaProduct-Swift
//
//  Created by User on 11/7/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit
import AlamofireNetworkActivityIndicator
import CocoaLumberjack
import Braintree

/// Class for module assembly
class AppDependencies: NSObject {
    private var mainWireFrame : LoginWireframe?
    private var presenterHome: SettingsHomeModuleProtocol?

    override init() {
        super.init()
        configureLibraries()
        configureDependencies()
    }

    /// clears session and redirects page to Log In
    func showLoginViewAndClearSession(InWindow window: UIWindow) {
        presenterHome?.logout()
        mainWireFrame?.presentLoginViewInterfaceFromWindow(Window: window)
    }

    /// presents login view in window. First Module/Page
    func installRootViewController(InWindow window : UIWindow) {
        mainWireFrame?.presentLoginViewInterfaceFromWindow(Window: window)
    }
    
    func applicationOpensURL(_ url: URL, withOptions options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare(iDooh.kPayURLScheme) == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        return false
    }

    /// assembly of dependencies appwide and modules
    func configureDependencies() {
        // Root Level Classes
        let root = RootWireframe()
        let store = StoreCoreData()
        let webservice = StoreWebClient()
//        let webserviceFake = StoreWebClientFake()
        let webserviceMagento = StoreWebClientMagento()
        let session = Session.sharedSession
        let syncEngine = SyncEngine()
        
        syncEngine.session = session
        webservice.session = session
        syncEngine.webservice = webservice

        // Wireframes
        let loginWireframe = LoginWireframe()
        let createAccountWireframe = CreateAccountWireframe()
        let forgotPasswordWireframe = ForgotPasswordWireframe()
        let homeWireframe = HomeWireframe()
        let settingsWireframe = SettingsWireframe()
        let settingsProfileWireframe = SettingsProfileWireframe()
        let settingsChangeEmailWireframe = SettingsChangeEmailWireframe()
        let settingsChangePasswordWireframe = SettingsChangePasswordWireframe()
        let qrCodeWireframe = QRCodeWireframe()
        let productListWireframe = ProductListViewWireframe()
        let productDetailWireframe = ProductDetailWireframe()
        let shopCartWireframe = ShopCartWireframe()
        let checkOutWireframe = CheckOutWireframe()
        let orderHistoryWireframe = OrderHistoryWireframe()

        //Login Module Classes
        let userManager = UserManager()
        let loginInteractor = LogInInteractor()
        let loginPresenter = LogInPresenter()
        
        userManager.store = store
        
        loginInteractor.manager = userManager
        loginInteractor.webService = webservice
        loginInteractor.webServiceMagento = webserviceMagento
        loginInteractor.session = session
        loginInteractor.output = loginPresenter
        loginInteractor.syncEngine = syncEngine
        
        loginPresenter.interactor = loginInteractor
        loginPresenter.loginWireframe = loginWireframe
        
        loginWireframe.loginPresenter = loginPresenter
        loginWireframe.rootWireFrame = root
        loginWireframe.createAccountWireframe = createAccountWireframe
        loginWireframe.homeWireFrame = homeWireframe
        loginWireframe.forgotPasswordWireframe = forgotPasswordWireframe
        
        mainWireFrame = loginWireframe
        syncEngine.managerUser = userManager

        //Create Account Classes
        let createAccountInteractor = CreateAccountInteractor()
        let createAccountPresenter = CreateAccountPresenter()

        createAccountInteractor.createAccountManager = userManager
        createAccountInteractor.webService = webservice
        createAccountInteractor.output = createAccountPresenter

        createAccountPresenter.interactor = createAccountInteractor
        createAccountPresenter.wireframeCreateAccount = createAccountWireframe

        createAccountWireframe.presenter = createAccountPresenter
        
        //Forgot Password Classes
        let forgotPassInteractor = ForgotPassInteractor()
        let forgotPassPresenter = ForgotPassPresenter()
        
        forgotPassInteractor.webservice = webservice
        forgotPassInteractor.output = forgotPassPresenter
        
        forgotPassPresenter.interactor = forgotPassInteractor
        forgotPassPresenter.wireframe = forgotPasswordWireframe
        
        forgotPasswordWireframe.forgotPasswordPresenter = forgotPassPresenter

        //Home Classes
        let homePresenter = HomeModulePresenter()
        
        homePresenter.homeWireframe = homeWireframe
        
        homeWireframe.presenter = homePresenter
        homeWireframe.settingsWireFrame = settingsWireframe
        homeWireframe.qrCodeWireframe = qrCodeWireframe
        homeWireframe.productListWireframe = productListWireframe
        homeWireframe.shopCartWireframe = shopCartWireframe
        homeWireframe.orderHistoryWireframe = orderHistoryWireframe
        
        //QRCode Classes
        let interactorQRCode = QRCodeInteractor()
        let presenterQRCode = QRCodePresenter()
        
        interactorQRCode.output = presenterQRCode
        interactorQRCode.outputCamera = presenterQRCode
        interactorQRCode.session = session
        
        interactorQRCode.webservice = webservice
//        interactorQRCode.webservice = webservice
//        interactorQRCode.webservice = webserviceMagento
        
        presenterQRCode.interactor = interactorQRCode
        presenterQRCode.wireframe = qrCodeWireframe
        
        qrCodeWireframe.presenter = presenterQRCode

        //Products Classes
        let productsManager = ProductManager()
        let productsInteractor = ProductInteractor()
        let productsPresenter = ProductListPresenter()
        let productDetailPresenter = ProductDetailPresenter()

        productsManager.store = store
        
        productsInteractor.manager = productsManager
        productsInteractor.webservice = webservice
//        productsInteractor.webservice = webservice
        productsInteractor.session = session
        productsInteractor.outputList = productsPresenter
        productsInteractor.outputDetail = productDetailPresenter
        productsInteractor.syncEngine = syncEngine
        
        productsPresenter.interactor = productsInteractor
        productsPresenter.productListWireframe = productListWireframe
        productDetailPresenter.interactor = productsInteractor
        
        productListWireframe.productsListPresenter = productsPresenter
        productListWireframe.productsListInteractor = productsInteractor
        productListWireframe.productDetailWireFrame = productDetailWireframe
        productDetailWireframe.productDetailPresenter = productDetailPresenter
        
        interactorQRCode.manager = productsManager
        
        homeWireframe.productsPresenter = productsPresenter
        syncEngine.managerProduct = productsManager
        
        //Order History Classes
        let orderHistoryManager = HistoryManager()
        let orderHistoryInteractor = HistoryInteractor()
        let orderHistoryPresenter = OrderHistoryPresenter()
        
        orderHistoryManager.store = store
        
        orderHistoryInteractor.manager = orderHistoryManager
        orderHistoryInteractor.session = session
        orderHistoryInteractor.output = orderHistoryPresenter
        orderHistoryInteractor.syncEngine = syncEngine
        orderHistoryInteractor.webservice = webservice
        
        syncEngine.managerHistory = orderHistoryManager
        
        orderHistoryPresenter.interactor = orderHistoryInteractor
        orderHistoryPresenter.orderHistoryWireframe = orderHistoryWireframe
        
        orderHistoryWireframe.orderHistoryPresenter = orderHistoryPresenter
        
        //Check Out Classes
        let checkOutInteractor = CheckOutInteractor()
        let checkOutPresenter = CheckOutPresenter()
        
        checkOutInteractor.session = session
        checkOutInteractor.webservice = webservice
        checkOutInteractor.session = session
        checkOutInteractor.output = checkOutPresenter
        checkOutInteractor.managerHistory = orderHistoryManager
        
        checkOutPresenter.interactor = checkOutInteractor
        checkOutPresenter.wireframeCheckOut = checkOutWireframe
        
        checkOutWireframe.presenter = checkOutPresenter
        checkOutWireframe.homeWireframe = homeWireframe
        
        //Shop Cart Classes
        let shopCartManager = ShopCartManager()
        let shopCartInteractor = ShopCartInteractor()
        let shopCartPresenter = ShopCartPresenter()
        
        shopCartManager.store = store
        
        shopCartInteractor.manager = shopCartManager
        shopCartInteractor.session = session
        shopCartInteractor.output = shopCartPresenter
        
        shopCartPresenter.interactor = shopCartInteractor
        shopCartPresenter.shopCartWireframe = shopCartWireframe
        
        shopCartWireframe.shopCartPresenter = shopCartPresenter
        shopCartWireframe.productDetailWireframe = productDetailWireframe
        shopCartWireframe.checkOutWireframe = checkOutWireframe
        
        checkOutInteractor.manager = shopCartManager

        //Settings Classes
        let settingsHomePresenter = SettingsPresenterHome()
        
        settingsHomePresenter.wireframeSettings = settingsWireframe
        
        settingsWireframe.settingsPresenter = settingsHomePresenter
        settingsWireframe.profileSettingsWireframe = settingsProfileWireframe
        settingsWireframe.changeEmailSettingsWireframe = settingsChangeEmailWireframe
        settingsWireframe.changePasswordSettingsWireframe = settingsChangePasswordWireframe
        
        presenterHome = settingsHomePresenter

        //Profile Settings Classes
        let settingsManager = SettingsManager()
        let settingsInteractor = SettingsInteractor()
        let profileSettingsPresenter = SettingsPresenterProfile()

        settingsManager.store = store
        
        settingsInteractor.manager = settingsManager
        settingsInteractor.webservice = webservice
        settingsInteractor.session = session
        settingsInteractor.outputProfile = profileSettingsPresenter
        settingsInteractor.outputHome = settingsHomePresenter

        settingsHomePresenter.interactor = settingsInteractor
        profileSettingsPresenter.interactor = settingsInteractor
        profileSettingsPresenter.profileSettingsWireframe = settingsProfileWireframe
        
        settingsProfileWireframe.presenter = profileSettingsPresenter

        //Change Email Settings Classes
        let changeEmailSettingsPresenter = SettingsPresenterEmail()
        
        settingsInteractor.outputEmail = changeEmailSettingsPresenter
        
        changeEmailSettingsPresenter.interactor = settingsInteractor
        changeEmailSettingsPresenter.changeEmailSettingsWireframe = settingsChangeEmailWireframe
        
        settingsChangeEmailWireframe.presenter = changeEmailSettingsPresenter

        //Change Password Settings Classes
        let changePasswordSettingsPresenter = SettingsPresenterPassword()
        
        settingsInteractor.outputPassword = changePasswordSettingsPresenter
        
        changePasswordSettingsPresenter.interactor = settingsInteractor
        changePasswordSettingsPresenter.changePasswordSettingsWireframe = settingsChangePasswordWireframe
        
        settingsChangePasswordWireframe.presenter = changePasswordSettingsPresenter
        
        //Shop Cart Classes
//        let shopCartManager = ShopCartManager()
//        let shopCartInteractor = ShopCartInteractor()
//
//        shopCartManager.store = store
//
//        shopCartInteractor.manager = shopCartManager
        
        productsInteractor.managerShopCart = shopCartManager
    }

    /// configures appwide libraries being used by the app
    func configureLibraries() {
        // BTApp
        BTAppSwitch.setReturnURLScheme(iDooh.kPayURLScheme)
        DDLog.add(DDTTYLogger.sharedInstance)
        DDLog.add(DDASLLogger.sharedInstance)

        // Logger
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7

        DDLog.add(fileLogger)

        DDLogVerbose("Verbose")
        DDLogDebug("Debug")
        DDLogInfo("Info")
        DDLogWarn("Warn")
        DDLogError("Error")

        #if DEV
            DDLogInfo("Development Environment")
        #elseif QA
            DDLogInfo("QA Environment")
        #elseif PROD
            DDLogInfo("Production Environment")
        #endif

        // Alamofire
        NetworkActivityIndicatorManager.shared.isEnabled = true
        NetworkActivityIndicatorManager.shared.startDelay = 0
    }
}
