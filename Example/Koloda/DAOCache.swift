//
//  DAOCache.swift
//  Koloda
//
//  Created by Helena Leitão on 17/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation


class DAOCache {
    
    private func getPath()->String {
        
        let rootPath: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let plistPath = rootPath.stringByAppendingString("/User.plist")
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(plistPath) {
            
            let bundlePath: String? = NSBundle.mainBundle().pathForResource("User", ofType: "plist")
            
            if let bundle = bundlePath {
                do {
                    try fileManager.copyItemAtPath(bundle, toPath: plistPath)
                }
                catch let error as NSError {
                    print("Erro ao copiar User.plist do mainBundle para plistPath: \(error.description)")
                }
            }
            else {
                print("User.plist não está no mainBundle")
            }
        }
        return plistPath
    }
    
    func saveUser () {
    
        let plistPath = self.getPath()
        let user = User.singleton
        
        let dict = NSMutableDictionary()
        
        dict["name"] = user.name
        dict["location"] = user.location
        dict["womenPreference"] = user.womenPreference
        dict["menPreference"] = user.menPreference
        dict["kidsPreference"] = user.kidsPreference
        
        dict.writeToFile(plistPath, atomically: true)
        
    }
    
    func loadUser() {
        
        let plistPath = getPath()
        let user = User.singleton
        
        let dict = NSMutableDictionary(contentsOfFile: plistPath)
        
        user.name = dict?.valueForKey("name") as! String!
        user.location = dict?.valueForKey("location") as! String!
        user.womenPreference = dict?.valueForKey("womenPreference") as! Bool!
        user.menPreference = dict?.valueForKey("menPreference") as! Bool!
        user.kidsPreference = dict?.valueForKey("kidsPreference") as! Bool!

    
    }
    
    
    
    
    
}