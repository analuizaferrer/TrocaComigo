//
//  LoginViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        email.attributedPlaceholder = NSAttributedString(string:"email", attributes:[NSForegroundColorAttributeName: UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)])
        password.attributedPlaceholder = NSAttributedString(string:"password", attributes:[NSForegroundColorAttributeName: UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)])
        
        let paddingEmail = UIView(frame: CGRectMake(0, 0, 20, self.email.frame.height))
        email.leftView = paddingEmail
        email.leftViewMode = UITextFieldViewMode.Always
        
        let paddingPassword = UIView(frame: CGRectMake(0, 0, 20, self.password.frame.height))
        password.leftView = paddingPassword
        password.leftViewMode = UITextFieldViewMode.Always
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        let dao = DAO()
        
        
        func loginCallback (user:FIRUser?, error:NSError?) {
            if error == nil {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("home")
                self.presentViewController(homeViewController, animated: true, completion: nil)
                dao.registerUser("Ana", userID: "AoWn5e2J4kTaINJ5DCnZ5k3lSSF3")
            } else {
                let alert = UIAlertController(title: "Error", message: "Ta errado fdp", preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)

                alert.addAction(cancel)
                self.presentViewController(alert, animated: true, completion: nil)
            }

        }
        
        dao.login(email.text!, password: password.text!, callback: loginCallback)
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("signup")
        self.presentViewController(homeViewController, animated: true, completion: nil)
    }
    

}
