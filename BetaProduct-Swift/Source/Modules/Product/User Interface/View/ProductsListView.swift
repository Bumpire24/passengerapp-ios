//
//  ProductsListView.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 12/14/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ProductsListView: BaseView, ProductsListViewProtocol {
    @IBOutlet weak var productsListCollectionView: UICollectionView!
    @IBOutlet weak var deleteProductButton: UIButton!
    @IBOutlet weak var deleteButtonContainer: IDoohRoundedNegativeButtonContainerView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteButtonContainer: IDoohRoundedPositiveButtonContainerView!
    @IBOutlet weak var productListEmptyView: UIView!
    @IBOutlet weak var productImageBackground: UIImageView!
    
    var eventHandler : ProductListModuleProtocol?
    var productListWireframe : ProductListViewWireframe?
    var products : [ProductListItem]?
    var currentSelectedImageIndexPath = IndexPath(row: 0, section: 0)
    
    let cellScaling: CGFloat = 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        let layout = productsListCollectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        productsListCollectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        productsListCollectionView?.dataSource = self
        productsListCollectionView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getAllProducts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTheme() {
        productImageBackground.image = UIImage(named: "ProductsBackground.png")
    }
    
    func getAllProducts() {
        eventHandler?.getAllProducts()
    }
    
    func displayProducts(_ products: [ProductListItem]) {
        self.products = products
        guard self.products == nil || self.products?.count == 0 else {
            toggleProductListComponentVisibility(shouldBeVisible: true)
            productsListCollectionView.reloadData()
            return
        }
        
        toggleProductListComponentVisibility(shouldBeVisible: false)
    }
    
    func toggleProductListComponentVisibility(shouldBeVisible : Bool) {
        productListEmptyView.isHidden = shouldBeVisible
        productsListCollectionView.isHidden = !shouldBeVisible
        deleteProductButton.isHidden = !shouldBeVisible
        deleteButtonContainer.isHidden = !shouldBeVisible
        favoriteButton.isHidden = !shouldBeVisible
        favoriteButtonContainer.isHidden = !shouldBeVisible
    }
    
    func popProductItem() {
        
    }
    
    func deleteProductItemFromCollection(isSuccessfullyDeleted : Bool, message : String) {
        guard isSuccessfullyDeleted else {
            displayDialogMessage(withTitle: "Products",
                                 messageContent: message,
                                 affirmativeButtonCaption: "OK",
                                 currentViewController: self,
                                 messageStatus: isSuccessfullyDeleted,
                                 successCompletion: {},
                                 failureCompletion: {})
            return
        }
        getAllProducts()
    }
    
    // MARK: UI Actions
    @IBAction func removeProductItemFromList(_ sender: Any) {
        displayDialogMessage(withTitle: "Product", messageContent: "Are you sure you want to delete this product?", negativeButtonCaption: "Yes", affirmativeButtonCaption: "No", currentViewController: self, messageStatus: true, successCompletion: {}, failureCompletion: {
            self.eventHandler?.removeProductItem(withIndex: self.currentSelectedImageIndexPath.item)
        })
    }
    
    @IBAction func markProductItemAsFavorite(_ sender: Any) {
        
    }
}

extension ProductsListView : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let productCount = self.products?.count != nil ? self.products!.count : 0
        return productCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsListCollectionCell", for: indexPath) as! ProductsListCollectionViewCell
        
        return populateProductCell(withImageURL: products![indexPath.item].imageURL, forCell: cell, atIndex: indexPath)
    }
    
    func populateProductCell(withImageURL imageURLString: String? = nil, forCell cell: ProductsListCollectionViewCell, atIndex indexPath: IndexPath) -> ProductsListCollectionViewCell {
        DispatchQueue.global(qos: .userInitiated).async {
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                self.generateImageFromURL(forCell: cell, urlString: imageURLString)
                cell.productName.text = self.products![indexPath.item].name
                let htmlBasedText = self.products![indexPath.item].description
                cell.productDescription.text = htmlBasedText?.htmlToString
            }
        }
        
        return cell
    }
}

extension ProductsListView : UIScrollViewDelegate, UICollectionViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = productsListCollectionView.contentOffset
        visibleRect.size = productsListCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = productsListCollectionView.indexPathForItem(at: visiblePoint) ?? IndexPath.init(item: 0, section: 0)
        currentSelectedImageIndexPath = visibleIndexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelectedImageIndexPath = indexPath
        productListWireframe?.displayProductDetail(withIndex: indexPath.item)
    }
}

extension ProductsListView {
    func generateImageFromURL(forCell cell: ProductsListCollectionViewCell, urlString: String? = nil) {
        guard (urlString?.isEmpty)! else {
            UIImage().createAlamofireImage(withURLString: urlString!, completionClosure: ({(imageReturned) in
                cell.productImageView.image =  imageReturned
                cell.productImageView.contentMode = UIViewContentMode.scaleAspectFit
            }))
            return
        }
    }
}
