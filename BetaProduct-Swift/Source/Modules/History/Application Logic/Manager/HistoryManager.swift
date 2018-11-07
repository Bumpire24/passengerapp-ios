//
//  HistoryManager.swift
//  BetaProduct-Swift
//
//  Created by User on 2/1/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class HistoryManager: NSObject {
    var store: StoreProtocol?
    
    func updateOrder(withOrder orders: [Order], withUser user: User, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        let predicate = NSPredicate.init(format: "status != %d AND id == %d", Status.Deleted.rawValue, user.id)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            switch response {
            case .success(let value):
                if let userM = value?.first as? ManagedUser {
                    let ordersM = userM.orders.map({$0 as! ManagedOrder})
                    orders.forEach({ order in
                        let orderM = ordersM.first(where: {$0.orderId == order.orderId})
                        orderM?.modifiedAt = order.modifiedAt
                        orderM?.createdAt = order.createdAt
                        let orderItemsM = orderM?.orderitems.map({$0 as! ManagedOrderItem})
//                        print("TEST: %@", orderM!.modifiedAt)
                        order.items.forEach({ orderItem in
                            let orderItemM = orderItemsM?.first(where: {$0.orderItemId == orderItem.orderItemId})
                            orderItemM?.orderStatus = orderItem.orderStatus
                            orderItemM?.price = orderItem.price
                            orderItemM?.quantity = orderItem.quantity
                            orderItemM?.productName = orderItem.productName
                            orderItemM?.currency = orderItem.currency
                            orderItemM?.createdAt = orderItem.createdAt
                            orderItemM?.modifiedAt = orderItem.modifiedAt
                            orderItemM?.productId = orderItem.productId
                            orderItemM?.productImage = orderItem.productImage
//                            print("TEST: " + orderItemM!.productName)
                        })
                    })
                    
                    self.store?.saveWithCompletionBlock(block: { response in
                        block(.success(true))
                    })
                } else {
                    block(.failure(iDoohError.genericError()))
                }
            case .failure(let error): block(.failure(error))
            }
        })
    }
    
    func retrieveOrder(withUser user: User, withCompletionBlock block: @escaping CompletionBlock<[Order]>) {
        let predicate = NSPredicate.init(format: "status != %d AND id == %d", Status.Deleted.rawValue, user.id)
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: false)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate,
                            withSortDescriptors: nil,
                            withCompletionBlock: { response in
                                switch response {
                                case .success(let value):
                                    let managedUser = value?.first as! ManagedUser
                                    block(.success(self.orderFromManagedOrder(mOrders: managedUser.orders.sortedArray(using: [sortDescriptor]).map({$0 as! ManagedOrder}))))
                                case .failure(let error): block(.failure(error))
                                }
        })
    }
    
    func createOrder(withOrder order: Order, withUserEmail email: String, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        createOrder(withOrders: [order], withUserEmail: email, withCompletionBlock: block)
    }
    
    func createOrder(withOrders orders: [Order], withUserEmail email: String, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        // Get User first
        let predicate = NSPredicate.init(format: "status != %d AND email == %@", Status.Deleted.rawValue, email)
        store?.fetchEntries(withEntityName: "User", withPredicate: predicate, withSortDescriptors: nil, withCompletionBlock: { response in
            switch response {
            case .success(let value):
                let mUser = value?.first as! ManagedUser
                // Make Order and OrderItems
                orders.forEach({ order in
                    // check if record already exists
                    if let _ = mUser.orders.map({$0 as! ManagedOrder}).first(where: {$0.orderId == order.orderId}) {
                        return
                    }
                    let mOrder = self.store?.newOrder()
                    mOrder?.orderId = order.orderId
                    mOrder?.status = Status.Active.toInt16()
                    mOrder?.syncStatus = SyncStatus.Created.toInt16()
                    mOrder?.createdAt = order.createdAt
                    mOrder?.modifiedAt = order.modifiedAt
                    order.items.forEach({ orderItem in
                        let mOrderItem = self.store?.newOrderItem()
                        mOrderItem?.orderItemId = orderItem.orderItemId
                        mOrderItem?.orderStatus = orderItem.orderStatus
                        mOrderItem?.price = orderItem.price
                        mOrderItem?.quantity = orderItem.quantity
                        mOrderItem?.status = Status.Active.toInt16()
                        mOrderItem?.syncStatus = SyncStatus.Created.toInt16()
                        mOrderItem?.productName = orderItem.productName
                        mOrderItem?.currency = orderItem.currency
                        mOrderItem?.createdAt = orderItem.createdAt
                        mOrderItem?.modifiedAt = orderItem.modifiedAt
                        mOrderItem?.productId = orderItem.productId
                        mOrderItem?.productImage = orderItem.productImage
                        // Add OrderItem to Order
                        mOrder?.addOrderItem(orderitem: mOrderItem!)
                    })
                    // Add Order to User
                    mUser.addOrder(order: mOrder!)
                })
                // Save
                self.store?.saveWithCompletionBlock(block: {response in
                    switch response {
                    case .success(_): block(.success(true))
                    case .failure(let error): block(.failure(error))
                    }
                })
            case .failure(let error): block(.failure(error))
            }
        })
    }
    
    private func orderFromManagedOrder(mOrders: [ManagedOrder]) -> [Order] {
        var value = [Order]()
        mOrders.forEach { mOrder in
            var order = Order()
            order.userId = Int(mOrder.user.id)
            order.orderId = mOrder.orderId
            order.createdAt = mOrder.createdAt
            order.modifiedAt = mOrder.modifiedAt
            let mOrderItems = mOrder.orderitems.map({ $0 as! ManagedOrderItem })
            order.items = mOrderItems.map({ mOrderItem in
                var orderItem = OrderItem()
                orderItem.orderItemId = mOrderItem.orderItemId
                orderItem.productId = mOrderItem.productId
                orderItem.productName = mOrderItem.productName
                orderItem.currency = mOrderItem.currency
                orderItem.quantity = mOrderItem.quantity
                orderItem.price = mOrderItem.price
                orderItem.orderStatus = mOrderItem.orderStatus
                orderItem.productImage = mOrderItem.productImage
                return orderItem
            })
            value.append(order)
        }
        return value
    }
}
