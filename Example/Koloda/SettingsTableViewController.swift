//
//  SettingsTableViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 14/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        self.profileImage.clipsToBounds = true
//        
//        if let user = FIRAuth.auth()?.currentUser {
//            FIRDatabase.database().reference().child("profile").child(user.uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
//                // Get user value
//               self.nameLabel.text = snapshot.value!["name"] as? String
//            }) { (error) in
//                print(error.localizedDescription)
//            }
//        } else {
//            nameLabel.text = "Name"
//        }
        
       // self.nameLabel.text = DAO().getName()
        
        let user = UIImage(named: "user-fill")
        let imageView = UIImageView(image: user)
        self.navigationItem.titleView = imageView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func image(sender: AnyObject) {
        print("o botao ta funfando")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 1:
            performSegueWithIdentifier("profile", sender: self)
            break
        case 2:
            performSegueWithIdentifier("closet", sender: self)
            break
        case 3:
            performSegueWithIdentifier("settings", sender: self)
            break
        default:
            print("pmsdinv")
        }
    }
    
    override func viewDidLayoutSubviews() {
        if self.tableView.respondsToSelector(Selector("setSeparatorInset:")) {
            self.tableView.separatorInset = UIEdgeInsetsZero
        }
        if self.tableView.respondsToSelector(Selector("setLayoutMargins:")) {
            self.tableView.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
}
