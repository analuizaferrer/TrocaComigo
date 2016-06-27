//
//  DAO.swift
//  Koloda
//
//  Created by Helena Leitão on 08/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Firebase

class DAO {
   
    // MARK: Referência para o Realtime Database
    let rootRef = FIRDatabase.database().reference()
    
    // MARK: Referência para o Storage
    let storage = FIRStorage.storage()

    /* MARK: Function registerUser
     Registers the user on the realtime database using the id from the authorization */
    func registerUser(name: String, location: String, userID: String) {
        if name != "" {
            self.rootRef.child("profile").child(userID).child("name").setValue(name)
        }
        if location != "" {
            self.rootRef.child("profile").child(userID).child("location").setValue(location)
        }
        User.singleton.id = userID
    }
    
    /* MARK: Function registerProduct
     Registers the product using the owners id */
    func registerProduct(category: String, subcategory: String, description: String, brand: String, size: String, condition: String, userID: String, images: [NSData]) {
        let key = self.rootRef.child("product").childByAutoId().key
        let child = self.rootRef.child("product").child(key)

        child.child("category").setValue(category)
        child.child("subcategory").setValue(subcategory)
        child.child("description").setValue(description)
        child.child("brand").setValue(brand)
        child.child("size").setValue(size)
        child.child("condition").setValue(condition)
        child.child("userid").setValue(userID)
        
        if images.count > 0 {
            let storageRef = self.storage.referenceForURL("gs://project-8034361784340242301.appspot.com")
            var cont = 1
            for image in images {
                
                //let dictionary
                
                let imageRef = storageRef.child(userID).child("products").child(key).child("image\(cont)")
                
                _ = imageRef.putData(image, metadata: nil) { metadata, error in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        _ = metadata!.downloadURL
                    }
                }
                
                cont += 1
            }
        }
        let product = Product(category: category, subcategory: subcategory, description: description, condition: condition, size: size, brand: brand, images: images)
    
        User.singleton.products.append(product)
        DAOCache().saveUser()
    }
    
    // REGISTER LIKES
    func registerLikes(likedUserID: String, likedProductID: String) {
        
        let user = FIRAuth.auth()?.currentUser
        
        let idLike = "\(likedProductID)" + " " + "\(user!.uid)"
        
        let timestamp: String = NSDate().getCurrentShortDate()
        
        self.rootRef.child("profile").child(likedUserID).child("likes").child(idLike).setValue(timestamp)

    }
    
    func registerProfilePic(imageData: NSData) {
        if let user = FIRAuth.auth()?.currentUser {
            let storageRef = self.storage.referenceForURL("gs://project-8034361784340242301.appspot.com")
            let imageRef = storageRef.child(user.uid).child("profile").child("image")
          
            _ = imageRef.putData(imageData, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    _ = metadata!.downloadURL
                }
            }
        }
    }
    
    func getImages(ids: [String], callback:([Image]) -> Void) -> Void  {
        var images: [Image] = []
        let loadImagesGroup = dispatch_group_create()
        
        print("entrou aqui")
        
        if (FIRAuth.auth()?.currentUser) != nil {
          
            let storageRef = self.storage.referenceForURL("gs://project-8034361784340242301.appspot.com")
            
            for id in ids {
                
                for product in productsArray {
                    
                    if product.id == id {
                        
                        let userid = product.userid
                        let imageRef = storageRef.child(userid).child("products").child(id).child("image1")
                        dispatch_group_enter(loadImagesGroup)
                        imageRef.dataWithMaxSize(18752503, completion: { (data, error) in
                            if error == nil {
                                let img = Image(image: data!, owner: id)
                                images.append(img)
                                print("appeding")
                            }
                            dispatch_group_leave(loadImagesGroup)
                        })
                    }
                }
            }
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let timeout = dispatch_time(DISPATCH_TIME_NOW, Int64(100 * Double(NSEC_PER_SEC)))
            let ok = dispatch_group_wait(loadImagesGroup, timeout) == 0
            dispatch_async(dispatch_get_main_queue()) {
                guard ok else {
                    callback([])
                    return
                }
                callback(images)
            }
        }
    }
    
    func getClosetImages(ids: [String], callback:([NSData]) -> Void) -> Void  {
        var images: [NSData] = []
        let loadImagesGroup = dispatch_group_create()

        let storageRef = self.storage.referenceForURL("gs://project-8034361784340242301.appspot.com")
        for id in ids {
            for product in User.singleton.products {
                if product.id == id {
                        let userid = product.userid
                        let imageRef = storageRef.child(userid).child("products").child(id).child("image1")
                        dispatch_group_enter(loadImagesGroup)
                        imageRef.dataWithMaxSize(18752503, completion: { (data, error) in
                            if error == nil {
                                images.append(data!)
                            }
                            dispatch_group_leave(loadImagesGroup)
                        })
                        
                    }
                }
            }
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let timeout = dispatch_time(DISPATCH_TIME_NOW, Int64(100 * Double(NSEC_PER_SEC)))
            let ok = dispatch_group_wait(loadImagesGroup, timeout) == 0
            dispatch_async(dispatch_get_main_queue()) {
                guard ok else {
                    callback([])
                    return
                }
                callback(images)
            }
        }
    }

    /* MARK: Function createAccount
     Gets the email and password typed by the user and saves on the database */
    func createAccount(name: String, username: String, password: String, callback: FIRAuthResultCallback) {
        FIRAuth.auth()?.createUserWithEmail(username, password: password, completion: callback)
    }
   
    /* MARK: Function login
     Gets the email and password typed by the user and logs in */
    func login(username: String, password: String, callback:FIRAuthResultCallback) {
        FIRAuth.auth()?.signInWithEmail(username, password: password, completion:callback)
    }

    /* MARK: Function logout
     Logs out of the application */
    func logout() {
        try! FIRAuth.auth()!.signOut()
    }
    
    /* MARK: Function updateName
     Updates current user's name */
    func updateName(name: String) {
        if let user = FIRAuth.auth()?.currentUser {
            self.registerUser(name, location: "", userID: user.uid)
        } else {
            // No user is signed in.
        }
    }
    
    /* MARK: Function updatelocation
     Updates current user's location */
    func updateLocation(location: String) {
        if let user = FIRAuth.auth()?.currentUser {
            self.registerUser("", location: location, userID: user.uid)
        } else {
            // No user is signed in.
        }
    }

    func getName(callback:(FIRDataSnapshot) -> Void)->Void {
        if let user = FIRAuth.auth()?.currentUser {
            self.rootRef.child("profile").child(user.uid).child("name").observeSingleEventOfType(.Value, withBlock: callback) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func getLocation(callback:(FIRDataSnapshot) -> Void)->Void {
        if let user = FIRAuth.auth()?.currentUser {
            self.rootRef.child("profile").child(user.uid).child("location").observeSingleEventOfType(.Value, withBlock: callback) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func getID()->String {
        if let user = FIRAuth.auth()!.currentUser {
            return user.uid
        }
        return "user not found"
    }
    
    // SEARCH FOR MATCH (searches if the user whose product you like already likes a product of yours)
    func searchForMatch(ownerID: String, callback: Bool -> Void)->Void {
        
        var didRegisterSwap = false
        let user = FIRAuth.auth()?.currentUser

        self.rootRef.child("profile").child(user!.uid).observeEventType(.Value, withBlock: { (snapshot: FIRDataSnapshot) in
            print("entrou aqui 2")
            
            for (item, value) in snapshot.value as! [String : AnyObject] {
              
                if item == "likes" {
                   
                    print("entrou aqui 3")
                    let likesDict = value as! [String : AnyObject]
                   
                    for (like, _) in likesDict {
                        
                        let fullID = String(like)
                        let fullNameArr = fullID.characters.split{$0 == " "}.map(String.init)
                    
                        if fullNameArr[1] == ownerID {
                          
                            self.rootRef.child("profile").child(user!.uid).child("likes").child(like).removeValue()
                            self.registerSwap((user?.uid)!, id2: ownerID)
                            didRegisterSwap = true
                        }
                    }
                }
            }
            callback(didRegisterSwap)
        })
    }
    
    func registerSwap(id1: String, id2: String) {
        
        let swap = "\(id1)" + " " + "\(id2)"
        
        let timestamp: String = NSDate().getCurrentShortDate()
        
        self.rootRef.child("swaps").child(swap).setValue(timestamp)
        
    }
    
    func generateProductsArray(callback:([Product]) -> Void) -> Void {
        
        let user = FIRAuth.auth()?.currentUser
        
        self.rootRef.child("product").observeSingleEventOfType(.Value, withBlock: { snapshot in
           
            var products : [Product] = []
            
            for (index, value) in snapshot.value as! [String : AnyObject] {
               
                let productDict = value as! [String : AnyObject]
                let product : Product = Product(dict: productDict, index: index)
                
                if user?.uid != product.userid {
                    
                    products.append(product)
                } else {
                    User.singleton.products.append(product)
                }
            }
            callback(products)
        })
    }

    func saveUserInfoToSingleton(callback:(User) -> Void) -> Void {
        
        let thisUser = FIRAuth.auth()?.currentUser
        
        self.rootRef.child("profile").child(thisUser!.uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            User.singleton.id = snapshot.key
            
            User.singleton.name = snapshot.value!["name"] as! String
            User.singleton.location = snapshot.value!["location"] as! String
            
            DAOCache().saveUser()
            
        })
    }
    
    func getOwnerName(userID: String, callback: String->Void)->Void {
        
        var username: String!
        
        self.rootRef.child("profile").child(userID).observeEventType(.Value, withBlock: { snapshot in
            username = snapshot.value!["name"] as! String
            print(username)
            callback(username)
        })
    }

    func getProfilePic(userID: String, callback: UIImage->Void)->Void {
        
        let storageRef = self.storage.referenceForURL("gs://project-8034361784340242301.appspot.com")
        let imageRef = storageRef.child(userID).child("profile").child("image")
        var profilePic: UIImage!
        
        func imageCallback(data: NSData?, error: NSError?) {
            if error != nil {
                print(error?.localizedDescription)
                print("deu erro")
                profilePic = UIImage(named: "user-fill")
            } else {
                print("nao deu erro")
                profilePic = UIImage(data: data!)
            }
            callback(profilePic)
        }
    
        imageRef.dataWithMaxSize(1 * 1024 * 1024, completion: imageCallback)
    }
}