//
//  DepartmentViewController.swift
//  Koloda
//
//  Created by Ana Luiza Ferrer on 6/17/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class DepartmentViewController: UIViewController {
    
    var productImages = [String]()
    var category: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func women(sender: AnyObject) {
        self.category = "women"
        performSegueWithIdentifier("segueToCategoriesViewController", sender: self)
    }
    
    @IBAction func men(sender: AnyObject) {
        self.category = "men"
        performSegueWithIdentifier("segueToCategoriesViewController", sender: self)
    }

    @IBAction func kids(sender: AnyObject) {
        self.category = "kids"
        performSegueWithIdentifier("segueToCategoriesViewController", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segueToCategoriesViewController") {
            
            let categoriesVC = segue.destinationViewController as! CategoriesViewController
            
           categoriesVC.category = self.category
            categoriesVC.productImages = self.productImages
        }

    }

}
