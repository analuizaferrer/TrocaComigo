//
//  AppDelegate.swift
//  Koloda
//
//  Created by Eugene Andreyev on 07/01/2015.
//  Copyright (c) 07/01/2015 Eugene Andreyev. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FIRApp.configure()
        
        UINavigationBar.appearance().barTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        
        
        
        /* ~~~ NOTIFICATIONS ~~~ */

        
        /* identificar as ações que o usuário pode fazer */
        let swapAction = UIMutableUserNotificationAction()
        swapAction.identifier = "didSwap"
        swapAction.title = "Swap"
        
        /* identificar as categorias de notificações que pretendo enviar */
        let swapCategory = UIMutableUserNotificationCategory()
        swapCategory.identifier = "itWorked"
        
        /* notificações no watch são mostradas no default context */
        // The default context is the lock screen.
        swapCategory.setActions([swapAction],
                                forContext: UIUserNotificationActionContext.Default)
        
        /* contexto mínimo é importante porque as notificações podem ser mostradas no iphone */
        // The minimal context is when the user pulls down on a notification banner.
        swapCategory.setActions([swapAction],
                                forContext: UIUserNotificationActionContext.Minimal)
        
        /* descrição do que o usuário vai ter quando a notificação aparecer */
        let settings = UIUserNotificationSettings(forTypes: [
                                                            UIUserNotificationType.Alert,
                                                            UIUserNotificationType.Badge,
                                                            UIUserNotificationType.Sound
                                                            ],
                                                  categories: [swapCategory])
        
        /* nesse ponto, o sistema pede por permissão para mostrar notificações */
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

