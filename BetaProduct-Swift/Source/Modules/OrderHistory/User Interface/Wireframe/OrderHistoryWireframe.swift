//
//  OrderHistoryWireframe.swift
//  BetaProduct-Swift
//
//  Created by User on 2/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

let orderHistoryViewIdentifier = "OrderHistoryView"

class OrderHistoryWireframe: BaseWireframe {
    var orderHistoryView : OrderHistoryView?
    var orderHistoryPresenter : OrderHistoryPresenter?
    var orderHistoryWireframe : OrderHistoryWireframe?
    
    func configuredViewController(_ viewController: HomeView) -> UIViewController {
        let orderHistoryViewControl = orderHistoryViewController()
        orderHistoryViewControl.tabBarItem = UITabBarItem.init(title: "HISTORY", image: UIImage.init(imageLiteralResourceName: "orderHistory"), tag: 1)
        orderHistoryView = orderHistoryViewControl
        orderHistoryView?.eventHandler = orderHistoryPresenter!
        orderHistoryPresenter?.orderHistoryView = orderHistoryView
        viewController.navigationController?.pushViewController(orderHistoryViewControl, animated: true)
        return orderHistoryViewControl
    }
    
    func orderHistoryViewController() -> OrderHistoryView {
        let orderHistoryViewController = mainStoryBoard().instantiateViewController(withIdentifier: orderHistoryViewIdentifier) as! OrderHistoryView
        return orderHistoryViewController
    }

}
