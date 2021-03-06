//
//  ProfileTableViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 16/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var switchWomen: UISwitch!
    @IBOutlet weak var switchMen: UISwitch!
    @IBOutlet weak var switchKids: UISwitch!
    
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
        
        nameField.delegate = self
        locationField.delegate = self
        
        DAOCache().loadUser()
        
        if User.singleton.name != nil {
            self.nameField.text = User.singleton.name
        }
        if User.singleton.location != nil {
            self.locationField.text = User.singleton.location
        }
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callbackName(snapshot: FIRDataSnapshot) {
        self.nameField.text = snapshot.value! as? String
    }
    
    func callbackLocation(snapshot: FIRDataSnapshot) {
        self.locationField.text = snapshot.value! as? String
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let exitAccount = UIAlertAction(title: "Log out", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction) in
                self.performSegueWithIdentifier("backToLogin", sender: self)
            })
            
            alert.addAction(exitAccount)
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(cancel)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

extension ProfileTableViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        if textField.tag == 0 {
            DAO().updateName(textField.text!)
            User.singleton.name = textField.text
            DAOCache().saveUser()
        } else if textField.tag == 1 {
            DAO().updateLocation(textField.text!)
            User.singleton.location = textField.text
            DAOCache().saveUser()
        }
    }
}