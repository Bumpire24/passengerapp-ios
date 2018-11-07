//
//  ProductDetailView.swift
//  BetaProduct-Swift DEV
//
//  Created by User on 12/18/17.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ProductDetailView: BaseView, ProductDetailViewProtocol {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: IDoohProductNameLabel!
//    @IBOutlet weak var productDescription: IDoohProductDescriptionLabel!
    @IBOutlet weak var productPrice: IDoohProductDescriptionLabel!
    @IBOutlet weak var addToCart: IDoohFloatingPrimaryButton!
    @IBOutlet weak var addToCartRoundedContainer: IDoohRoundedPositiveButtonContainerView!
    @IBOutlet weak var productDescription: IDoohRegularContainerTextView!
    
    var eventHandler : ProductDetailModuleProtocol?
    var currentProductItem : ProductDetailItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchProductDetail(ofItemIndexAt itemIndex: Int) {
        eventHandler?.getProductItem(atIndex: itemIndex)
    }
    
    func fetchProductDetail(ofProductById id: Int) {
        eventHandler?.getProductItem(byId: id)
    }
    
    func displayProductInformation(productItem: ProductDetailItem) {
        currentProductItem = productItem
        productName.text = productItem.name
        generateImageFromURL(withURLString: productItem.imageURL)
        
        let htmlBasedText = productItem.description
        productDescription.text = htmlBasedText?.htmlToString
        productDescription.placeHolder.isHidden = true
        productPrice.text = productItem.price
        changeAddToShopcartImage(itemAddedToCart: (currentProductItem?.isAddedToShopCart)!)
    }
    
    func displayMessage(_ message: String) {
        displayDialogMessage(withTitle: "",
                             messageContent: message,
                             negativeButtonCaption: "Cancel",
                             affirmativeButtonCaption: "OK",
                             currentViewController: self,
                             messageStatus: false)
    }
    
    func changeAddToShopcartImage(itemAddedToCart : Bool) {
        guard itemAddedToCart else {
            addToCart.setImage(UIImage(named: "addToCart"), for: .normal)
            addToCart.setImage(UIImage(named: "addedToCart"), for: .selected)
            return
        }
        
        addToCart.setImage(UIImage(named: "addedToCart"), for: .normal)
        addToCart.setImage(UIImage(named: "addToCart"), for: .selected)
    }
    
    func dismissDetailView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Action Methods
    
    @IBAction func dismissPopup(_ sender: Any) {
        dismissDetailView()
        
    }
    
    @IBAction func addItemToCart(_ sender: Any) {
        guard (currentProductItem?.isAddedToShopCart)! else {
            eventHandler?.addToCartById((currentProductItem?.id)!)
            return
        }
        
        eventHandler?.removeFromCartById((currentProductItem?.id)!)
    }
}

extension ProductDetailView {
    func generateImageFromURL(withURLString urlString: String? = nil) {
        guard (urlString?.isEmpty)! else {
            UIImage().createAlamofireImage(withURLString: urlString!, completionClosure: ({(imageReturned) in
                self.productImage.image =  imageReturned
               self.productImage.contentMode = UIViewContentMode.scaleAspectFit
            }))
            return
        }
    }
}
