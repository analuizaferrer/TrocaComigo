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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        locationField.delegate = self
        
        let dao = DAO()
        dao.getName(callbackName)
        dao.getLocation(callbackLocation)
        dao.getWomenPreferences(callbackWomen)
        dao.getMenPreferences(callbackMen)
        dao.getKidsPreferences(callbackKids)
    }
    
    override func viewWillAppear(animated: Bool) {
        let dao = DAO()
        dao.getName(callbackName)
        dao.getLocation(callbackLocation)
        dao.getWomenPreferences(callbackWomen)
        dao.getMenPreferences(callbackMen)
        dao.getKidsPreferences(callbackKids)
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
    
    func callbackWomen(snapshot: FIRDataSnapshot) {
        if snapshot.value! as? String == "true" {
            self.switchWomen.setOn(true, animated: false)
        } else {
            self.switchWomen.setOn(false, animated: false)
        }
    }
    
    func callbackMen(snapshot: FIRDataSnapshot) {
        if snapshot.value! as? String == "true" {
            self.switchMen.setOn(true, animated: false)
        } else {
            self.switchMen.setOn(false, animated: false)
        }
    }
    
    func callbackKids(snapshot: FIRDataSnapshot) {
        if snapshot.value! as? String == "true" {
            self.switchKids.setOn(true, animated: false)
        } else {
            self.switchKids.setOn(false, animated: false)
        }
    }

    @IBAction func womenSwitchDidChange(sender: AnyObject) {
        let dao = DAO()
        dao.registerUserPreferences("women", status: switchWomen.on)
    }
    
    @IBAction func menSwitchDidChange(sender: AnyObject) {
        let dao = DAO()
        dao.registerUserPreferences("men", status: switchMen.on)
    }
    
    @IBAction func kidsSwitchDidChange(sender: AnyObject) {
        let dao = DAO()
        dao.registerUserPreferences("kids", status: switchKids.on)
    }
    
}

extension ProfileTableViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        if textField.tag == 0 {
            DAO().updateName(textField.text!)
            globalUser.name = textField.text
            DAOCache().saveUser()
        } else if textField.tag == 1 {
            DAO().updateLocation(textField.text!)
            globalUser.location = textField.text
            DAOCache().saveUser()
        }
    }
}