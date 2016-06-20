//
//  CreateAccountViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 09/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordConf: UITextField!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.attributedPlaceholder = NSAttributedString(string:"name", attributes:[NSForegroundColorAttributeName: UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)])
        email.attributedPlaceholder = NSAttributedString(string:"email", attributes:[NSForegroundColorAttributeName: UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)])
        password.attributedPlaceholder = NSAttributedString(string:"password", attributes:[NSForegroundColorAttributeName: UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)])
        passwordConf.attributedPlaceholder = NSAttributedString(string:"confirm password", attributes:[NSForegroundColorAttributeName: UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)])
        
        let paddingName = UIView(frame: CGRectMake(0, 0, 20, self.name.frame.height))
        name.leftView = paddingName
        name.leftViewMode = UITextFieldViewMode.Always
        
        let paddingEmail = UIView(frame: CGRectMake(0, 0, 20, self.email.frame.height))
        email.leftView = paddingEmail
        email.leftViewMode = UITextFieldViewMode.Always
        
        let paddingPassword = UIView(frame: CGRectMake(0, 0, 20, self.password.frame.height))
        password.leftView = paddingPassword
        password.leftViewMode = UITextFieldViewMode.Always
        
        let paddingPasswordConf = UIView(frame: CGRectMake(0, 0, 20, self.passwordConf.frame.height))
        passwordConf.leftView = paddingPasswordConf
        passwordConf.leftViewMode = UITextFieldViewMode.Always
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                    dao.registerUser(name.text!, location: "", userID: (user?.uid)!)
                    
                } else {
                    let errorCode = FIRAuthErrorCode(rawValue: (error?.code)!)!
                    switch (errorCode) {
                    case .ErrorCodeEmailAlreadyInUse:
                        print("Handle email already in use")
                    case FIRAuthErrorCode.ErrorCodeInvalidEmail:
                        print("Handle invalid email")
                    case .ErrorCodeWrongPassword:
                        print("Handle wrong password")
                    case .ErrorCodeWeakPassword:
                        print("Handle weak password")
                    // case . CONTINUE
                    default:
                        print("Handle default situation")
                    }


                    let alert = UIAlertController(title: "Error", message: error?.domain, preferredStyle: UIAlertControllerStyle.Alert)
                    let cancel = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
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
