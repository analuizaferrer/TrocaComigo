//
//  DetailsTableViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 17/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Firebase

class DetailsTableViewController: UITableViewController {

    var productImages: [NSData]!
    var category: String!
    var subcategory: String!
    var userid: String!
  
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var brand: UITextField!
    @IBOutlet weak var size: UITextField!
    @IBOutlet weak var condition: UITextField!
    
    // changes sections' header atributtes
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor(red:0.14, green:0.14, blue:0.14, alpha:1.0)
        header.textLabel!.font = UIFont(name: "Montserrat-Regular", size: 14)
        header.textLabel!.frame = header.frame
        header.textLabel!.textAlignment = NSTextAlignment.Left
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 4 {
            let alert = UIAlertController(title: "Are you sure you want to delete your product registration?", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let removeCurrentProduct = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction) in
                self.performSegueWithIdentifier("backToCloset", sender: self)
            })
            
            alert.addAction(removeCurrentProduct)
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancel)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    @IBAction func done(sender: AnyObject) {
        let dao = DAO()
        
        self.userid = dao.getID()
        if userid != "user not found" {
            dao.registerProduct(self.category, subcategory: self.subcategory, description: self.descriptionText.text, brand: self.brand.text!, size: self.size.text!, condition: self.condition.text!, userID: userid, images: self.productImages)
        }
        self.performSegueWithIdentifier("backToCloset", sender: self)
    }
}
