//
//  OrderHistoryPresenter.swift
//  BetaProduct-Swift
//
//  Created by Enrico Boller on 12/02/2018.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class OrderHistoryPresenter: NSObject, OrderHistoryModuleProtocol, HistoryInteractorOutput {
    var interactor : HistoryInteractorInput?
    var orderHistoryView : OrderHistoryViewProtocol?
    var orderHistoryWireframe : OrderHistoryWireframe?
    
    //MARK: OrderHistoryModuleProtocol Method
    func retrieveOrderHistory() {
        interactor?.retrieveItems()
    }
    
    //MARK: HistoryInteractorOutput Protocol Method
    func gotItems(items: [OrderDisplayItem]) {
        guard items.count > 0 else {
            orderHistoryView?.displayEmptyOrderHistory()
            return
        }
        
        orderHistoryView?.displayOrderHistory(items: items)
    }
}
