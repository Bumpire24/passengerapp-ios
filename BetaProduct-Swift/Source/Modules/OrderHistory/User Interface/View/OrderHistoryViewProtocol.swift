//
//  OrderHistoryViewProtocol.swift
//  BetaProduct-Swift
//
//  Created by User on 2/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

protocol OrderHistoryViewProtocol {
  func displayOrderHistory(items: [OrderDisplayItem])
  func displayEmptyOrderHistory()
}
