//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop
import Firebase

private var numberOfCards: UInt = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.0
private var currentProductId = productsArray[0].id
private var currentOwnerId = productsArray[0].userid
private var currentIndex = 0

class BackgroundAnimationViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    //PRODUCT DETAILS VIEW
    
    var productDetailsView : UIView!
    var detailsPageControl : UIPageControl!
    
    var matchProduct = ""
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("entrou no view did load do koloda")
 
        if productsArray.count >= 0 {
            numberOfCards = UInt(productsArray.count)
        }
        
        DAOCache().loadUser()
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name:"GrandHotel-Regular", size: 27)!, NSForegroundColorAttributeName: UIColor(red: 0.25, green: 0.75, blue: 0.76, alpha: 1)]
    }
    
    func leaveDetails () {
        productDetailsView.removeFromSuperview()
        self.navigationController?.navigationBarHidden = false
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() { // like
        kolodaView?.swipe(SwipeResultDirection.Right)
        print(currentOwnerId)
        print(currentProductId)
        DAO().registerLikes(currentOwnerId, likedProductID: currentProductId!)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
}

extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
}

extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    func configurePageControl() {
        self.detailsPageControl.numberOfPages = 6
        self.detailsPageControl.currentPage = 0
        self.detailsPageControl.tintColor = UIColor.cyanColor()
        self.detailsPageControl.pageIndicatorTintColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        self.detailsPageControl.currentPageIndicatorTintColor = UIColor(red: 0.25, green: 0.75, blue: 0.76, alpha: 1)
        self.detailsPageControl.layer.position.y = 355
        productDetailsView.addSubview(detailsPageControl)
    }
    
    func configureProductDetailsView() {
        
        var i = 0
        
        while (productsArray[i].id != productsIDs[currentIndex]) {
            i+=1
        }
        
        productDetailsView = UIView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        productDetailsView.backgroundColor = UIColor.whiteColor()
        
        detailsPageControl = UIPageControl(frame: CGRectMake(0,0,view.frame.width, view.frame.width))
        configurePageControl()
        
        let leaveDetailsViewButton = UIButton(frame: CGRectMake(20,20,40,40))
        leaveDetailsViewButton.setBackgroundImage(UIImage(named: "down"), forState: .Normal)
        leaveDetailsViewButton.addTarget(self, action: #selector(BackgroundAnimationViewController.leaveDetails), forControlEvents: UIControlEvents.TouchUpInside)
        productDetailsView.addSubview(leaveDetailsViewButton)
        
        let brandLabel = UILabel(frame: CGRectMake(20, 393,335, 20))
        brandLabel.text = ("BRAND \(productsArray[i].brand)")
        productDetailsView.addSubview(brandLabel)
        
        let sizeLabel = UILabel(frame: CGRectMake(20, 413,335, 20))
        sizeLabel.text = ("SIZE \(productsArray[i].size)")
        productDetailsView.addSubview(sizeLabel)
        
        let usageLabel = UILabel(frame: CGRectMake(20, 433,335, 20))
        usageLabel.text = ("USAGE \(productsArray[i].condition)")
        productDetailsView.addSubview(usageLabel)
        
        let descriptionLabel = UILabel(frame: CGRectMake(20, 465,335, 60))
        descriptionLabel.text = (productsArray[i].description)
        productDetailsView.addSubview(descriptionLabel)
        
        let likeButton = UIButton(frame: CGRectMake(238,570,72,72))
        likeButton.setBackgroundImage(UIImage(named:"heart-round-fill"), forState: .Normal)
        likeButton.addTarget(self, action: #selector(BackgroundAnimationViewController.rightButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        productDetailsView.addSubview(likeButton)
        
        let rejectButton = UIButton(frame: CGRectMake(66,570,72,72))
        rejectButton.setBackgroundImage(UIImage(named:"deny-fill"), forState: .Normal)
        rejectButton.addTarget(self, action: #selector(BackgroundAnimationViewController.leftButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        productDetailsView.addSubview(rejectButton)
        
        i = 0
        
    }
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
        self.navigationController?.navigationBarHidden = true
        configureProductDetailsView()
        view.addSubview(productDetailsView)
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return numberOfCards
    }
    
    func koloda(koloda: KolodaView, viewForCardAtIndex index: UInt) -> UIView {
       
        if imagesArray.count > Int(index) {
            let data = imagesArray[Int(index)].image
            currentIndex = Int(index)
            currentProductId = imagesArray[Int(index)].owner
            
            for product in productsArray {
                if product.id == imagesArray[Int(index)].owner {
                     currentOwnerId = product.userid
                }
            }
            
            let image = UIImage(data: data)
            let imageView = UIImageView(image: image)
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.layer.cornerRadius = 15.0
            imageView.clipsToBounds = true
            
            return imageView
        }
        
        return UIView()
    }

    func koloda(koloda: KolodaView, viewForCardOverlayAtIndex index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
    
    func koloda(koloda: KolodaView, didSwipeCardAtIndex index: UInt, inDirection direction: SwipeResultDirection) {
      
        if direction == .Right {
            DAO().registerLikes(currentOwnerId, likedProductID: currentProductId!)
            DAO().searchForMatch(currentOwnerId, callback: { snapshot in
            })
        }
    }
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}
