//
//  CheckOutViewClasses.swift
//  BetaProduct-Swift
//
//  Created by User on 1/31/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

enum CheckOutSteps: Int {
    case Step01 = 0
    case Step02 = 1
    case Step03 = 2
    case Step04 = 3
    case Step05 = 4
}

protocol CheckOutNextStepDelegate {
    func executeNextStep(nextPageNumber : CheckOutSteps)
}

class CheckOutViewClasses: BaseView {
    
    var eventHandler : CheckOutModuleProtocol?
    var checkOutWireframe : CheckOutWireframe?
    var homeWireFrame : HomeWireframe?
    var delegate: CheckOutNextStepDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
