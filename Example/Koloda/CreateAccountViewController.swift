//
//  CreateAccountViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 09/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordConf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("login")
        self.presentViewController(homeViewController, animated: true, completion: nil)

    }
    
    @IBAction func signUp(sender: AnyObject) {
        if password.text == passwordConf.text {
            let dao = DAO()
            
            func signUpCallback (user: FIRUser?, error: NSError?) {
                if error == nil {
                    
                    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("home")
                    self.presentViewController(homeViewController, animated: true, completion: nil)
                
                    dao.registerUser(name.text!, userID: (user?.uid)!)
                    
                } else {
                    let alert = UIAlertController(title: "Error", message: "Ta errado fdp", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
                    
                    alert.addAction(cancel)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }
            
            dao.createAccount(name.text!, username: email.text!, password: password.text!, callback: signUpCallback)

        } else {
            let alert = UIAlertController(title: "Error", message: "Passwords don't match.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
