//
//  HistoryInteractorIO.swift
//  BetaProduct-Swift
//
//  Created by User on 2/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol HistoryInteractorInput {
    func retrieveItems()
}

protocol HistoryInteractorOutput {
    func gotItems(items: [OrderDisplayItem])
}
