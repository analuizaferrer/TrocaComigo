//
//  InterfaceController.swift
//  SwapIt-Watch Extension
//
//  Created by Bia Lemos on 6/25/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var swapImage: WKInterfaceImage!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if WCSession.isSupported() {
            WCSession.defaultSession().delegate = self
            WCSession.defaultSession().activateSession()
        } else {
            presentAlertControllerWithTitle("Error", message: "Oops!", preferredStyle: .Alert, actions: [])
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func session(session: WCSession, didReceiveMessageData messageData: NSData) {
        let getSwapImage = UIImage(data: messageData)
        swapImage.setImage(getSwapImage)
    }
    
    
    
//    
//    override func handleActionWithIdentifier(identifier: String?, forRemoteNotification remoteNotification: [NSObject : AnyObject]) {
//        if let notificationIdentifier = identifier {
//            if notificationIdentifier == "didSwap" {
//                swapImage.setImageData(identifier)
//            }
//        }
//    }
    
//    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
//        
//        guard let swapImage = UIImage(data: messageData) else {
//            return
//        }
//        
//        // throw to the main queue to upate properly
//        dispatch_async(dispatch_get_main_queue()) { [weak self] in
//            // update your UI here
//        }
//        
//        replyHandler(messageData)
//    }

}
