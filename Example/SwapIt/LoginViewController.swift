//
//  LoginViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Firebase

var productsArray: [Product] = []
var imagesArray: [Image] = []
var productsIDs: [String] = []

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func prepareForLogin(segue: UIStoryboardSegue) {
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        email.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    
    //    func textFieldDidBeginEditing(textField: UITextField) {
    //        if email.text == nil {
    //            email.placeholder = "email"
    //        } else {
    //            email.placeholder = nil
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.delegate = self
        password.delegate = self
        
        // change color of the placeholders
        email.attributedPlaceholder = NSAttributedString(string:"email", attributes:[NSForegroundColorAttributeName: UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)])
        password.attributedPlaceholder = NSAttributedString(string:"password", attributes:[NSForegroundColorAttributeName: UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)])
        
        // indent placeholders
        let paddingEmail = UIView(frame: CGRectMake(0, 0, 20, self.email.frame.height))
        email.leftView = paddingEmail
        email.leftViewMode = UITextFieldViewMode.Always
        
        let paddingPassword = UIView(frame: CGRectMake(0, 0, 20, self.password.frame.height))
        password.leftView = paddingPassword
        password.leftViewMode = UITextFieldViewMode.Always
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(sender: AnyObject) {
        let dao = DAO()
        
        func loginCallback (user:FIRUser?, error:NSError?) {
          
            if error == nil {
               
                let uniqueUser = User.singleton
                if uniqueUser.id != nil {
                   
                    if uniqueUser.id != user?.uid {
                        
                        uniqueUser.id = user?.uid
                        uniqueUser.name = nil
                        uniqueUser.location = nil
                        uniqueUser.profilePic = nil
                        uniqueUser.products.removeAll()
                        DAOCache().saveUser()
                        
                        DAO().saveUserInfoToSingleton({ user in })
                    }
                } else {
                    DAO().saveUserInfoToSingleton({ user in })
                }

                dao.generateProductsArray({ products in
                    
                    for product in products {
                        productsArray.append(product)
                        if productsIDs.count < 5 {
                            productsIDs.append(product.id!)
                        }
                    }
                    
                    dao.getImages(productsIDs, callback: { images in
    
                        for image in images {
                           imagesArray.append(image)
                            print(imagesArray.count)
                            print(productsArray.count)
                            if imagesArray.count == productsArray.count {
                                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let homeViewController: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("home")
                                self.presentViewController(homeViewController, animated: true, completion: nil)
                            }
                        }
                    })
                })
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Incorrect e-mail or password.", preferredStyle: UIAlertControllerStyle.Alert)
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
