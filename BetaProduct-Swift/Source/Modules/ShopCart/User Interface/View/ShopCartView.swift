//
//  ShopCartView.swift
//  BetaProduct-Swift
//
//  Created by Enrico Boller on 20/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ShopCartView: BaseView, ShopCartViewProtocol {
    @IBOutlet weak var shopCartList: UICollectionView!
    @IBOutlet weak var clearCartButton: IDoohDialogTertiaryButton!
    @IBOutlet weak var totalPriceLabel: IDoohInstructionLabel!
    @IBOutlet weak var totalPriceField: UITextField!
    @IBOutlet weak var emptyCartView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var shopCartBackground: UIImageView!
    
    var eventHandler : ShopCartModuleProtocol?
    var shopCartItems : ShopCartListDisplayItem?
    var currentSelectedImageIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage()
        shopCartList?.dataSource = self
        shopCartList?.delegate = self
        obtainShopCartList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        obtainShopCartList()
    }
    
    func setBackgroundImage() {
        shopCartBackground.image = UIImage(named: "ShopCartBackground.png")
    }
    
    func obtainShopCartList() {
        eventHandler?.getAllProducts()
    }
    
    func displayProducts(_ cart: ShopCartListDisplayItem) {
        self.shopCartItems = cart
        shopCartList.reloadData()
        self.totalPriceField.text = cart.totalPrice
        emptyCartView.isHidden = true
        contentView.isHidden = false
    }
    
    func displayEmptyProducts() {
        emptyCartView.isHidden = false
        contentView.isHidden = true
    }
    
    func obtainShopCartUpdates() {
        eventHandler?.getAllProducts()
    }
    
    //MARK: Action Methods
    @IBAction func shopCartItemTapped(_ sender: AnyObject) {
        let tappedProduct = shopCartItems?.items![currentSelectedImageIndexPath.item]
        let tappedProductID = tappedProduct?.productId
        eventHandler?.showProductDetailByID(tappedProductID ?? 0)
    }
    
    @IBAction func removeShopCartItem(_ sender: Any) {
        displayDialogMessage(withTitle: "Shop Cart",
                             messageContent: "Are you sure you want to delete this item on your cart?",
                             negativeButtonCaption: "Yes",
                             affirmativeButtonCaption: "No",
                             currentViewController: self,
                             messageStatus: true,
                             successCompletion: {},
                             failureCompletion: {
            
            if(self.shopCartItems?.items?.count == 1) {
                self.eventHandler?.deleteProduct(byIndex: 0)
                return
            }
            self.eventHandler?.deleteProduct(byIndex: self.currentSelectedImageIndexPath.item)
        })
    }
    
    @IBAction func decrementShopCartItem(_ sender: UIButton) {
        eventHandler?.subtractProductQuantity(byIndex: sender.tag)
    }
    
    @IBAction func incrementShopCartItem(_ sender: UIButton) {
        eventHandler?.addProductQuantity(byIndex: sender.tag)
    }
    
    @IBAction func removeAllCartItems(_ sender: Any) {
        displayDialogMessage(withTitle: "Shop Cart",
                             messageContent: "Are you sure you want to delete all items on your cart?",
                             negativeButtonCaption: "Yes",
                             affirmativeButtonCaption: "No",
                             currentViewController: self,
                             messageStatus: true,
                             successCompletion: {},
                             failureCompletion: {
            self.eventHandler?.clearAllProducts()
        })
    }
    
    @IBAction func proceedToCheckout(_ sender: Any) {
        eventHandler?.proceedToCheckOut()
    }
}

extension ShopCartView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let shopCartListCount = self.shopCartItems?.items?.count != nil ? self.shopCartItems?.items?.count : 0
        return shopCartListCount!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCartListCollectionCell", for: indexPath) as! ShopCartListCollectionViewCell
        
        return populateShopCartCell(withImageURL: self.shopCartItems?.items![indexPath.item].productImageURL, forCell: cell, atIndex: indexPath)
    }
    
    func populateShopCartCell(withImageURL imageURLString: String? = nil, forCell cell: ShopCartListCollectionViewCell, atIndex indexPath: IndexPath) -> ShopCartListCollectionViewCell {
        DispatchQueue.global(qos: .userInitiated).async {
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                self.generateImageFromURL(forCell: cell, urlString: imageURLString)
                cell.shopCartItemName.text = self.shopCartItems?.items![indexPath.item].productName
                let htmlBasedText = self.shopCartItems?.items![indexPath.item].productDescription
                cell.shopCartDescription.text = htmlBasedText?.htmlToString
                cell.shopCartQuantityField.text = self.shopCartItems?.items![indexPath.item].productQuantity
                cell.shopCartItemPriceField.text = self.shopCartItems?.items![indexPath.item].productPrice
                cell.shopCartItemProductIDLabel.text = String(describing: self.shopCartItems?.items![indexPath.item].productId)
                cell.shopCartIncrementButton.tag = indexPath.item
                cell.shopCartDecrementButton.tag = indexPath.item
            }
        }
        
        return cell
    }
}

extension ShopCartView : UIScrollViewDelegate, UICollectionViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = shopCartList.contentOffset
        visibleRect.size = shopCartList.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = shopCartList.indexPathForItem(at: visiblePoint)  ?? IndexPath.init(item: 0, section: 0)
        currentSelectedImageIndexPath = visibleIndexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedImageIndexPath = indexPath
        let tappedProduct = shopCartItems?.items![currentSelectedImageIndexPath.item]
        let tappedProductID = tappedProduct?.productId
        eventHandler?.showProductDetailByID(tappedProductID ?? 0)
    }
}

extension ShopCartView {
    func generateImageFromURL(forCell cell: ShopCartListCollectionViewCell, urlString: String? = nil) {
        guard (urlString?.isEmpty)! else {
            UIImage().createAlamofireImage(withURLString: urlString!, completionClosure: ({(imageReturned) in
                cell.shopCartItemImageView.image =  imageReturned
                cell.shopCartItemImageView.contentMode = UIViewContentMode.scaleAspectFit
            }))
            return
        }
    }
}
