//
//  SwapViewController.swift
//  Koloda
//
//  Created by Bia Lemos on 6/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import WatchConnectivity

class SwapViewController: UIViewController, WCSessionDelegate {
    
    @IBOutlet weak var warningText: UILabel!
    
    @IBOutlet weak var myClothe: UIImageView!
    
    @IBOutlet weak var yourClothe: UIImageView!
    
    var userImage1: UIImage!
    
    var userImage2: UIImage!
    
    var username: String!

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // verificar se o canal entre iphone e watch pode ser aberto
        if #available(iOS 9.0, *) {
            if WCSession.isSupported() {
                let wcsession = WCSession.defaultSession()
                wcsession.delegate = self
                wcsession.activateSession()
            }
        }
        
        
        let imageFromSwap = UIImage(named: "pizza")
        let dataFromSwap = UIImageJPEGRepresentation(imageFromSwap!, 1.0)
        
        if #available(iOS 9.0, *) {
            WCSession.defaultSession().sendMessageData(dataFromSwap!,
                                                       replyHandler: { (handler) -> Void in print(handler)},
                                                       errorHandler: { (error) -> Void in print(#file, error)})
        }

        self.warningText.text = "\(self.username) liked your clothing too!"

        
        self.myClothe.contentMode = UIViewContentMode.ScaleAspectFill
        self.myClothe.layer.cornerRadius = self.myClothe.frame.size.width / 2
        self.myClothe.layer.masksToBounds = false
        self.myClothe.clipsToBounds = true
        
        self.yourClothe.contentMode = UIViewContentMode.ScaleAspectFill
        self.yourClothe.layer.cornerRadius = self.yourClothe.frame.size.width / 2
        self.yourClothe.clipsToBounds = true

        // Do any additional setup after loading the view.
        self.myClothe.image = userImage1
        self.yourClothe.image = userImage2
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

