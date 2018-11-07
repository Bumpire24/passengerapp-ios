//
//  SyncEngine.swift
//  BetaProduct-Swift
//
//  Created by User on 11/8/17.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import CocoaLumberjack

class SyncEngine: SyncEngineProtocol {
    var managerHistory: HistoryManager?
    var managerUser: UserManager?
    var managerProduct: ProductManager?
    var webservice: StoreWebClientProtocol?
    var session: Session?
    
    func syncOrders(completionBlock block: @escaping (Response<Bool>) -> Void) {
        if isInitialSyncComplete() {
            syncOrdersByUpdateDate({ _ in
                block(.success(true))
            })
        } else {
            startInitialSync { _ in
                block(.success(true))
            }
        }
    }
    
    func syncUser(withUserNew userNew: User, withUserOld userOld: User, withCompletionBlock block: @escaping CompletionBlock<Bool>) {
        if userNew.modifiedAt > userOld.modifiedAt {
            managerUser?.updateUser(withUser: userNew, withCompletionBlock: { _ in
                block(.success(true))
            })
        } else {
            block(.success(false))
        }
    }
    
    func syncProducts(completionBlock block: @escaping CompletionBlock<Bool>) {
        guard let user = session?.getUserSessionAsUser() else {
            block(.failure(iDoohError.genericError()))
            return
        }
        
        managerProduct?.retrieveProducts(withUser: user, withCompletionBlock: { response in
            if response.isSuccess {
                let products = response.value!
//                var productsTobeUpdated: [Product]?
                let dispatchGroup = DispatchGroup()
                products.forEach({ product in
                    dispatchGroup.enter()
                    self.webservice?.GET(iDooh.kWSProducts(withID: String(product.productId)), parameters: nil, block: { responseWebservice in
                        switch responseWebservice {
                        case .success(let valueWebservice):
                            let productToBeUpdated = Product.init(dictionary: valueWebservice?.first as! [String: Any])
                            if productToBeUpdated.modifiedAt > product.modifiedAt {
                                self.managerProduct?.updateProduct(product: productToBeUpdated, withCompletionBlock: { _ in
                                    dispatchGroup.leave()
                                })
//                                productsTobeUpdated?.append(productToBeUpdated)
                            } else {
                                dispatchGroup.leave()
                            }
                        case .failure(_):
                            dispatchGroup.leave()
                            break
                        }
                        
                    })
                })
                dispatchGroup.notify(queue: .main, execute: {
                    block(.success(true))
//                    if let productsTobeUpdated = productsTobeUpdated {
//                        self.managerProduct?.updateProduct(products: productsTobeUpdated, withCompletionBlock: { _ in
//                            block(.success(true))
//                        })
//                    } else {
//                        block(.success(true))
//                    }
                })
            } else {
                block(.success(true))
            }
        })
    }
    
    /**
     Performs initial synchronization of webservice db and local db
    - Parameters:
        - block: Callback closure. see `CompletionBlockTypes.swift`
     */
    private func startInitialSync(_ block : @escaping CompletionBlock<Bool>) {
        guard let userId = session?.user?.id, let userEmail = session?.user?.email else {
            block(.failure(iDoohError.genericError()))
            return
        }
        
        webservice?.GET(iDooh.KWSUsersOrders(withID: String(userId)), parameters: nil, block: { response in
            switch response {
            case .success(let value):
                // make array of orders
                if let nonNilValue = value, let ordersRaw = nonNilValue as? [[String: Any]], ordersRaw.count > 0 {
                    var orders = [Order]()
                    ordersRaw.forEach({ orderRaw in
                        let order = self.orderFromDictionary(dataDict: orderRaw)
                        if let order = order {
                            orders.append(order)
                        }
                    })
                    if orders.count > 0 {
                        self.managerHistory?.createOrder(withOrders: orders, withUserEmail: userEmail, withCompletionBlock: { response in
                            self.markSyncAsComplete()
                            switch response {
                            case .success(_): block(.success(true))
                            case .failure(let error): block(.failure(error))
                            }
                        })
                    } else {
                        block(.failure(iDoohError.genericError()))
                    }
                }
            case .failure(let error):
                block(.failure(error))
            }
        })
    }
    
    private func syncOrdersByUpdateDate(_ block: @escaping CompletionBlock<Bool>) {
        guard let user = session?.getUserSessionAsUser() else {
            block(.failure(iDoohError.genericError()))
            return
        }
        
        managerHistory?.retrieveOrder(withUser: user, withCompletionBlock: { response in
            if response.isSuccess {
                let order = response.value!.max(by: { a, b in a.modifiedAt < b.modifiedAt})
                
                self.webservice?.GET(iDooh.kWSUsersOrders(withID: String(user.id), andWithUpdateDate: self.extractDateStringFromDate(date: order!.modifiedAt)), parameters: nil, block: { response in
                    switch response {
                    case .success(let value):
                        // make array of orders
                        if let nonNilValue = value, let ordersRaw = nonNilValue as? [[String: Any]], ordersRaw.count > 0 {
                            var orders = [Order]()
                            ordersRaw.forEach({ orderRaw in
                                let order = self.orderFromDictionary(dataDict: orderRaw)
                                if let order = order {
                                    orders.append(order)
                                }
                            })
                            if orders.count > 0 {
                                self.managerHistory?.updateOrder(withOrder: orders, withUser: user, withCompletionBlock: { response in
                                    switch response {
                                    case .success(_): block(.success(true))
                                    case .failure(let error): block(.failure(error))
                                    }
                                })
                            } else {
                                block(.failure(iDoohError.genericError()))
                            }
                        } else {
                            block(.failure(iDoohError.genericError()))
                        }
                    case .failure(let error):
                        block(.failure(error))
                    }
                })
            } else {
                block(.failure(iDoohError.genericError()))
            }
        })
    }
    
    private func extractDateStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd%20HH:mm:ss"
        let updateDate = dateFormatter.string(from: date)
        return updateDate
    }
    
    private func isInitialSyncComplete() -> Bool {
        guard let _ = UserDefaults.standard.value(forKey: iDooh.kSyncComplete) else { return false }
        return true
    }
    
    private func markSyncAsComplete() {
        UserDefaults.standard.set(iDooh.kSyncComplete, forKey: iDooh.kSyncComplete)
    }
    
    private func orderFromDictionary(dataDict: [String: Any]) -> Order? {
        var order = Order.init(dictionary: dataDict)
        if let orderItemsRaw = dataDict["order_items"] as? [[String: Any]], orderItemsRaw.count > 0 {
            orderItemsRaw.forEach({ orderItemRaw in
                let orderItem = OrderItem.init(dictionary: orderItemRaw)
                order.items.append(orderItem)
            })
            return order
        }
        return nil
    }
}
