//
//  ProductsListViewProtocol.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 12/15/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

protocol ProductsListViewProtocol {
    func displayProducts(_ products: [ProductListItem])
    func deleteProductItemFromCollection(isSuccessfullyDeleted : Bool, message : String)
}
