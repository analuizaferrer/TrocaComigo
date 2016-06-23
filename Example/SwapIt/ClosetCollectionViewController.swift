//
//  ClosetCollectionViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 18/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ClosetCollectionViewController: UICollectionViewController {
    
    private let leftAndRightPadding: CGFloat = 0.0
    private let numberOfItensPerRow: CGFloat = 3.0
    private let heightAdjustment: CGFloat = 30.0
    
    let teste1 = UIImage(named: "pizza")
    let teste2 = UIImage(named: "pizza")
    let teste3 = UIImage(named: "pizza")
    
    var productArrayCloset: [UIImage]! = []
    
    var productImages: [NSData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(User.singleton.products.count)
        
        let cellWidth = (CGRectGetWidth((collectionView?.frame)!) - leftAndRightPadding) / numberOfItensPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(cellWidth, cellWidth)
        
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        productArrayCloset.removeAll()
        
        if User.singleton.products.count > 0 {
            
            for i in closetArray {
                
                let image = UIImage(data: i)
                productArrayCloset.append(image!)
                
            }
            
            self.collectionView?.reloadData()
            
            
//            for product in User.singleton.products {
//                
//                let image = UIImage(data: product.images![0])
//                productArray.append(image!)
//                
//            }
//            self.collectionView?.reloadData()
        }
    }

//    func callback(data: NSData?, error: NSError?) {
//        if error == nil {
//            let image: UIImage = UIImage(data: data!)!
//            product.append(image)
//            print(product.count)
//        } else {
//            print(error)
//        }
//    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return productArrayCloset.count
    }
    
    private struct Storyboard {
        static let CellIdentifier = "closetCell"
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("closetCell", forIndexPath: indexPath) as! ClosetCollectionViewCell
        
        let thisProduct = productArrayCloset[indexPath.row]
        
        cell.productImageView.contentMode = UIViewContentMode.ScaleAspectFill
        cell.productImageView.image = thisProduct
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
