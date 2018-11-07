//
//  CheckOutPageViewController.swift
//  BetaProduct-Swift
//
//  Created by User on 1/30/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CheckOutPageViewController: UIPageViewController, CheckOutNextStepDelegate {
    var eventHandler : CheckOutModuleProtocol?
    var checkOutWireframe : CheckOutWireframe?
    var homeWireFrame : HomeWireframe?
    var presenter : CheckOutPresenter?
    var pageControl = UIPageControl(frame: .zero)
    
    //MARK: Lazy Implementation of View Controllers
    fileprivate lazy var pages: [CheckOutViewClasses] = {
        return [
            self.getViewController(withIdentifier: "CheckOutView"),
            self.getViewController(withIdentifier: "CheckOutPaymentMethodView"),
            self.getViewController(withIdentifier: "CheckOutBillingInfoView"),
            self.getViewController(withIdentifier: "CheckOutTermsAndConditionsView"),
            self.getViewController(withIdentifier: "CheckOutSummaryView")
        ]
        }() as! [CheckOutViewClasses]
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate   = self
        specifyEventHandlersAndWireframes()
        
        if let firstViewController = pages.first
        {
            presenter?.view = firstViewController as? CheckOutViewProtocol
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        setupPageControl()
    }
    
    //MARK: Helper Methods
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
    
    func specifyEventHandlersAndWireframes() {
        pages = pages.map {
            $0.checkOutWireframe = self.checkOutWireframe
            $0.eventHandler = self.eventHandler
            $0.homeWireFrame = self.homeWireFrame
            $0.delegate = self
            return $0
        }
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        let leading = NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.insertSubview(pageControl, at: 0)
        view.bringSubview(toFront: pageControl)
        view.addConstraints([leading, trailing, bottom])
    }
    
    //MARK: CheckOutNextStepDelegate Methods
    func executeNextStep(nextPageNumber : CheckOutSteps) {
        presenter?.view = pages[nextPageNumber.rawValue] as? CheckOutViewProtocol
        setViewControllers([pages[nextPageNumber.rawValue]], direction: .forward, animated: true, completion: nil)
        pageControl.currentPage = nextPageNumber.rawValue
    }
}

extension CheckOutPageViewController: UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController as! CheckOutViewClasses) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        presenter?.view = pages[previousIndex] as? CheckOutViewProtocol
        pageControl.currentPage = previousIndex
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
//        guard let viewControllerIndex = pages.index(of: viewController as! CheckOutViewClasses) else {
//            return nil
//        }
//        let nextIndex = viewControllerIndex + 1
//        pageControl.currentPage = nextIndex
        return nil
    }
}

extension CheckOutPageViewController: UIPageViewControllerDelegate { }
