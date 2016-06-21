//
//  SwapViewController.swift
//  Koloda
//
//  Created by Bia Lemos on 6/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class SwapViewController: UIViewController {
    
    @IBOutlet weak var warningText: UILabel!
    
    @IBOutlet weak var myClothe: UIImageView!
    
    @IBOutlet weak var yourClothe: UIImageView!
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myClothe.contentMode = UIViewContentMode.ScaleAspectFill
        self.myClothe.layer.cornerRadius = self.myClothe.frame.size.width / 2
        self.myClothe.layer.masksToBounds = false
        self.myClothe.clipsToBounds = true
        
        self.yourClothe.contentMode = UIViewContentMode.ScaleAspectFill
        self.yourClothe.layer.cornerRadius = self.yourClothe.frame.size.width / 2
        self.yourClothe.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

