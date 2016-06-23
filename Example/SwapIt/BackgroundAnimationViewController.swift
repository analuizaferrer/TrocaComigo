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

class BackgroundAnimationViewController: UIViewController {

    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    var productDetailsView : UIView!
    
    var matchProduct = ""
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("entrou no view did load do koloda")
        
//        productsArray.shuffle()
        
        DAOCache().loadUser()
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name:"GrandHotel-Regular", size: 27)!, NSForegroundColorAttributeName: UIColor(red: 0.25, green: 0.75, blue: 0.76, alpha: 1)]
        
        
        //PRODUCT DETAILS VIEW
        
        productDetailsView = UIView(frame: CGRectMake(0, 0, view.frame.width, view.frame.height))
        productDetailsView.backgroundColor = UIColor.whiteColor()
        
        let confirmButton = UIButton(frame: CGRectMake(238,558,72,72))
        let excludeButton = UIButton(frame: CGRectMake(66,558,72,72))
        
        confirmButton.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
        confirmButton.addTarget(self, action: #selector(PhotoViewController.confirmPhoto), forControlEvents: UIControlEvents.TouchUpInside)
        excludeButton.setBackgroundImage(UIImage(named: "trash"), forState: .Normal)
        excludeButton.addTarget(self, action: #selector(PhotoViewController.excludePhoto), forControlEvents: UIControlEvents.TouchUpInside)
        
        confirmationView.addSubview(confirmButton)
        confirmationView.addSubview(excludeButton)
        confirmationImageView = UIImageView(frame: CGRectMake(0,64,view.frame.width, 456))
        confirmationImageView.image = UIImage(named: "quadrado photo")
        confirmationView.addSubview(confirmationImageView)

        
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() { // dislke
        print("baksodjbhkfdiewpfdhskbvjosfkfjvckbhisdpaoj")
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() { // like self.rootRef.child("profile").child(idDonoProduto).child("likes").child(idUsuario).setValue(idProduto)
        kolodaView?.swipe(SwipeResultDirection.Right)
        DAO().registerLikes(currentOwnerId, likedProductID: currentProductId!)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    func callbackMatchProduct(snapshot: FIRDataSnapshot) {
        self.matchProduct = (snapshot.value! as? String)!
    }
}

extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
}

extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    func koloda(koloda: KolodaView, didSelectCardAtIndex index: UInt) {
       // UIApplication.sharedApplication().openURL(NSURL(string: "http://yalantis.com/")!)
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
            print("entrou no if do koloda")
            let data = imagesArray[Int(index)]
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
