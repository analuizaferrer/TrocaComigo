//
//  CategoriesViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 17/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    var productImages: [String]!
    var category: String!
    var subcategory: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func top(sender: AnyObject) {
        self.subcategory = "top"
        performSegueWithIdentifier("segueToDetailsTableViewController", sender: self)
    }
    
    @IBAction func bottom(sender: AnyObject) {
        self.subcategory = "bottom"
        performSegueWithIdentifier("segueToDetailsTableViewController", sender: self)
    }
    
    @IBAction func onePiece(sender: AnyObject) {
        self.subcategory = "one piece"
        performSegueWithIdentifier("segueToDetailsTableViewController", sender: self)
    }
    
    @IBAction func bags(sender: AnyObject) {
        self.subcategory = "bags"
        performSegueWithIdentifier("segueToDetailsTableViewController", sender: self)
    }
    
    @IBAction func footwear(sender: AnyObject) {
        self.subcategory = "footwear"
        performSegueWithIdentifier("segueToDetailsTableViewController", sender: self)
    }
    
    @IBAction func accessories(sender: AnyObject) {
        self.subcategory = "accessories"
        performSegueWithIdentifier("segueToDetailsTableViewController", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segueToDetailsTableViewController") {
            
            let detailsVC = segue.destinationViewController as! DetailsTableViewController
            
            detailsVC.category = self.category
            detailsVC.productImages = self.productImages
            detailsVC.subcategory = self.subcategory
        }
    }
}
