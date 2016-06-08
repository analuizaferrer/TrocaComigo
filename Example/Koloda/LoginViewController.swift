//
//  LoginViewController.swift
//  Koloda
//
//  Created by Helena Leitão on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(sender: AnyObject) {
        let dao = DAO()
        
        dao.login()
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        let dao = DAO()
        
        dao.createAccount()
    }
    

}
