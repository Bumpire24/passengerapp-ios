//
//  OrderHistoryView.swift
//  BetaProduct-Swift
//
//  Created by User on 2/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class OrderHistoryView: BaseView, OrderHistoryViewProtocol, UITableViewDelegate, UITableViewDataSource {
    var eventHandler : OrderHistoryModuleProtocol?
    var orderDisplayItems = [OrderDisplayItem]()
    
    @IBOutlet weak var emptyOrderHistoryView: UIView!
    @IBOutlet weak var emptyHeaderLabel: IDoohHeaderLabel!
    @IBOutlet weak var emptyInstructionsLabel: IDoohInstructionLabel!
    @IBOutlet weak var orderHistoryView: UIView!
    @IBOutlet weak var orderHistoryTableView: UITableView!
    @IBOutlet weak var orderHistoryBackground: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        orderHistoryTableView.delegate = self
        orderHistoryTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchOrderHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBackgroundImage()
        
    }
    func setBackgroundImage() {
        orderHistoryBackground.image = UIImage(named: "OrderHistoryBackground.png")
    }

    
    //MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderDisplayItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDisplayItems[section].items.count + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductDisplayCellHeader", for: indexPath) as! OrderHistoryTableViewCell
        guard orderDisplayItems.count > 0 else {
            return cell
        }
        
        let row = indexPath.row
        if row == 0 {
            // Headers
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "ProductDisplayCellHeader", for: indexPath) as! OrderHistoryTableViewCell
            headerCell.backgroundColor = iDoohStyle.iDoohTableViewHeaderCellsBackgroundColor
            headerCell.orderDate.text = "Order Date : \( Date().convertStringDateToMMMDDYYYY(dateStringToFormat: orderDisplayItems[indexPath.section].orderDate!))"
            return headerCell
        } else if row == orderDisplayItems[indexPath.section].items.count + 1 {
            // Footer
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "ProductDisplayCellFooter", for: indexPath) as! OrderHistoryTableViewCell
            headerCell.backgroundColor = iDoohStyle.iDoohTableViewHeaderCellsBackgroundColor
            headerCell.totalOrderPrice.text = "Total Price : \(String(describing: orderDisplayItems[indexPath.section].totalPrice!))"
            return headerCell
        } else {
            // Contents
            let unitString = Int(orderDisplayItems[indexPath.section].items[indexPath.row-1].orderQuantity!)! > 1 ? "Units" : "Unit"
            let contentCell = tableView.dequeueReusableCell(withIdentifier: "ProductDisplayCellContents", for: indexPath) as! OrderHistoryTableViewCell
            contentCell.backgroundColor = iDoohStyle.iDoohTableViewContentCellsBackgroundColor
            contentCell.productName.text = orderDisplayItems[indexPath.section].items[indexPath.row-1].productName!
            contentCell.productAmount.text = "\(String(describing: orderDisplayItems[indexPath.section].items[indexPath.row-1].orderQuantity!)) \(unitString) @ \(String(describing: orderDisplayItems[indexPath.section].items[indexPath.row-1].orderPrice!)) each"
            contentCell.productStatus.text = "\(String(describing: orderDisplayItems[indexPath.section].items[indexPath.row-1].orderStatus!)) Delivery Status"
            self.generateImageFromURL(forCell: contentCell, urlString: orderDisplayItems[indexPath.section].items[indexPath.row-1].orderProductImage)
            return contentCell
        }
        
        return cell
    }
    
    //MARK: Helper Methods
    func fetchOrderHistory() {
        eventHandler?.retrieveOrderHistory()
    }
    
    //MARK: OrderHistoryViewProtocol Methods
    func displayOrderHistory(items: [OrderDisplayItem]) {
        emptyOrderHistoryView.isHidden = true
        orderHistoryView.isHidden = false
        orderDisplayItems = items
        orderHistoryTableView.reloadData()
    }
    
    func displayEmptyOrderHistory() {
        emptyOrderHistoryView.isHidden = false
        orderHistoryView.isHidden = true
    }
}

extension OrderHistoryView {
    func generateImageFromURL(forCell cell: OrderHistoryTableViewCell, urlString: String? = nil) {
        guard (urlString?.isEmpty)! else {
            UIImage().createAlamofireImage(withURLString: urlString!, completionClosure: ({(imageReturned) in
                cell.productImageThumbnail.image = imageReturned
                cell.productImageThumbnail.contentMode = UIViewContentMode.scaleAspectFit
            }))
            return
        }
        
        cell.productImageThumbnail.image = UIImage(named: "NoPreviewImage.png")
        cell.productImageThumbnail.contentMode = UIViewContentMode.scaleAspectFit
    }
}
