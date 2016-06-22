//
//  DAOCache.swift
//  Koloda
//
//  Created by Helena Leitão on 17/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

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
    
    func saveUser() {
        let plistPath = self.getPath()
        let user = User.singleton
        
        let imageData: NSData
        if user.profilePic == nil {
            imageData = UIImagePNGRepresentation(UIImage(named:"profile")!)!

        }
        else {
            imageData = UIImagePNGRepresentation(user.profilePic!)!
        }
        let dict = NSMutableDictionary()
        
        let products: NSMutableArray = NSMutableArray(capacity: user.products.count)
        let productDict: NSMutableDictionary = NSMutableDictionary()
        
        for p in user.products {
            //let images: NSMutableArray = NSMutableArray(capacity: p.images.count)
            let imageDict: NSMutableDictionary = NSMutableDictionary()
        
            var cont = 0
           
            if p.category != nil {
                productDict["category"] = p.category
            }
            
            if p.subcategory != nil {
                 productDict["subcategory"] = p.subcategory
            }

            if p.description != nil {
                productDict["description"] = p.description
            }
        
            if p.condition != nil {
                productDict["condition"] = p.condition
            }
            
            if p.size != nil {
                productDict["size"] = p.size
            }
            
            if p.brand != nil {
                productDict["brand"] = p.brand
            }
            
            for image in p.images! {
                imageDict["image\(cont)"] = image
                cont += 1
            }
            
            productDict["Images"] = imageDict
        
            products.addObject(productDict)
        
        }
        
        dict["id"] = user.id
        dict["Products"] = products
        dict["name"] = user.name
        dict["location"] = user.location
        dict["womenPreference"] = user.womenPreference
        dict["menPreference"] = user.menPreference
        dict["kidsPreference"] = user.kidsPreference
        dict["profilePic"] = imageData
        
        dict.writeToFile(plistPath, atomically: true)
    }
    
    func loadUser() {
        let plistPath = getPath()
        let user = User.singleton
        
        let dict = NSMutableDictionary(contentsOfFile: plistPath)
        
        if dict?.valueForKey("id") != nil {
            user.id = dict?.valueForKey("id") as! String
        }
        
        if dict?.valueForKey("name") != nil {
            user.name = dict?.valueForKey("name") as! String!
        }
        
        if dict?.valueForKey("location") != nil {
            user.location = dict?.valueForKey("location") as! String!
        }
        
        if dict?.valueForKey("womenPreference") != nil {
            user.womenPreference = dict?.valueForKey("womenPreference") as! Bool!
        }
        
        if dict?.valueForKey("menPreference") != nil {
            user.menPreference = dict?.valueForKey("menPreference") as! Bool!
        }
        
        if dict?.valueForKey("kidsPreferences") != nil {
            user.kidsPreference = dict?.valueForKey("kidsPreference") as! Bool!
        }
        
        if dict?.valueForKey("profilePic") != nil {
            let imageData: NSData = dict?.valueForKey("profilePic") as! NSData!
            user.profilePic = UIImage(data: imageData)
        }
        //user.products = dict?.valueForKey("Products") as! [Product]
        
        if dict?.valueForKey("Products") != nil {
            let arrayDict = dict?.valueForKey("Products") as! NSMutableArray
        
            user.products.removeAll()
            
            for object in arrayDict {
                let dictProd = object as! NSMutableDictionary
                
                let imagesDict = dictProd.valueForKey("Images") as! NSMutableDictionary
                
                var images = [NSData]()
                var i = 0
                while (i < imagesDict.count) {
                    let imageData = NSData(data: imagesDict.valueForKey("image\(i)") as! NSData)
                    i += 1
                    images.append(imageData)
                }
                
                let product = Product(category: dictProd.valueForKey("category") as! String, subcategory: dictProd.valueForKey("subcategory") as! String, description: dictProd.valueForKey("description") as! String, condition: dictProd.valueForKey("condition") as! String, size: dictProd.valueForKey("size") as! String, brand: dictProd.valueForKey("brand") as! String, images: images)
                
                user.products.append(product)
            }
        }
    }
}