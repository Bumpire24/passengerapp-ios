//
//  QRCodeWireframe.swift
//  BetaProduct-Swift
//
//  Created by Enrico Boller on 20/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

let qrViewIdentifier = "QRView"

class QRCodeWireframe: BaseWireframe, HomeTabBarInterface {
    var qrCodeView : QRCodeView?
    var presenter : QRCodePresenter?
    
    func configuredViewController(_ viewController: HomeView) -> UIViewController {
        let newViewController = qrCodeViewController()
        newViewController.tabBarItem = UITabBarItem.init(title: "SCAN", image: UIImage.init(imageLiteralResourceName: "qr"), tag: 1)
        qrCodeView = newViewController
        qrCodeView?.eventHandler = presenter
        presenter?.view = qrCodeView
        return newViewController
    }
    
    func presentQRViewFromViewController(_ viewController: UIViewController) {
        let newViewController = qrCodeViewController()
        qrCodeView = newViewController
        qrCodeView?.eventHandler = presenter
        presenter?.view = qrCodeView
        viewController.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func qrCodeViewController() -> QRCodeView {
        let viewcontroller = mainStoryBoard().instantiateViewController(withIdentifier: qrViewIdentifier) as! QRCodeView
        return viewcontroller
    }
}
