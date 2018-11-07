//
//  HistoryInteractor.swift
//  BetaProduct-Swift
//
//  Created by User on 2/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class HistoryInteractor: HistoryInteractorInput {
    var manager: HistoryManager?
    var session: Session?
    var webservice: StoreWebClientProtocol?
    var syncEngine: SyncEngineProtocol?
    var output: HistoryInteractorOutput?
    
    func retrieveItems() {
        syncEngine?.syncOrders(completionBlock: { _ in
            self.retrieveOrdersFromCoreAndCallOutput()
        })
        
        // try to sync data first
//        if let syncEngine = syncEngine {
//            if syncEngine.isInitialSyncComplete() {
//                retrieveOrdersFromCoreAndCallOutput()
//            } else {
//                syncEngine.startInitialSync({ response in
//                    if response.isSuccess {
//                        self.retrieveOrdersFromCoreAndCallOutput()
//                    } else {
//                        self.output?.gotItems(items: [])
//                    }
//                })
//            }
//        } else {
//            output?.gotItems(items: [])
//        }
    }
    
    private func retrieveOrdersFromCoreAndCallOutput() {
        if let session = session {
            self.manager?.retrieveOrder(withUser: session.getUserSessionAsUser(), withCompletionBlock: { response in
                switch response {
                case .success(let value): self.output?.gotItems(items: self.ordersForDisplayFromOrderModel(model: value!))
                case .failure(_): self.output?.gotItems(items: [])
                }
            })
        } else {
            output?.gotItems(items: [])
        }
    }
    
    private func ordersForDisplayFromOrderModel(model: [Order]) -> [OrderDisplayItem] {
        var value = [OrderDisplayItem]()
        model.forEach { orderM in
            var order = OrderDisplayItem()
            order.totalPrice = String(orderM.items.map({$0.totalPrice}).reduce(0.00, +))
            order.orderDate = String(describing: orderM.createdAt)
            order.items = orderM.items.map({ orderItemM in
                var orderItem = OrderItemDisplayItem()
                orderItem.productName = orderItemM.productName
                orderItem.orderStatus = orderItemM.orderStatus
                orderItem.orderPrice = orderItemM.currency + " " + String(orderItemM.price)
                orderItem.orderQuantity = String(orderItemM.quantity)
                orderItem.orderTotalPrice = String(orderItemM.price * Double(orderItemM.quantity))
                orderItem.orderProductImage = orderItemM.productImage
                return orderItem
            })
            value.append(order)
        }
        return value
    }
}
