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
    
    var products: [UIImage]! = []
    
    var productImages: [NSData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        //TESTE
        var cont: Int = 0
        if productImages != nil {
            print("entrou")
            for data in productImages {
                print(cont)
                let image: UIImage = UIImage(data: data)!
                products.append(image)
                cont += 1
            }
        }
        //products = [teste1!,teste2!,teste3!]
        
        let cellWidth = (CGRectGetWidth((collectionView?.frame)!) - leftAndRightPadding) / numberOfItensPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(cellWidth, cellWidth)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.

    }

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return products.count
    }
    
    private struct Storyboard {
        static let CellIdentifier = "closetCell"
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("closetCell", forIndexPath: indexPath) as! ClosetCollectionViewCell
        
        let thisProduct = products[indexPath.row]
        
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
