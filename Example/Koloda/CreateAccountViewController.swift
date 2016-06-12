//
//  CreateAccountViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 09/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

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
    
    @IBAction func signUp(sender: AnyObject) {
        if password.text == passwordConf.text {
            let dao = DAO()
            
          //  dao.createAccount(email.text!, password: password.text!)

        } else {
            print("Password confirmation failed.")
        }
    }
}
