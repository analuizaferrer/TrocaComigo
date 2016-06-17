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
    }
    
    /* MARK: Function registerProduct
     Registers the product using the owners id */
    func registerProduct(department: String, category: String, subcategories: [String], description: String, brand: String, size: String, condition: String, userID: String) {
        let child = self.rootRef.child("product").childByAutoId()
        child.child("department").setValue(department) // women, men or kids
        child.child("category").setValue(category) // top, bottom, footwear, accessories, etc
        if subcategories.count > 0 { // ex: pants
            var cont: Int = 1
            for subcategory in subcategories {
                let sc: String = "subcategory" + String(cont)
                child.child(sc).setValue(subcategory)
                cont += 1
            }
        }
        child.child("description").setValue(description)
        child.child("brand").setValue(brand)
        child.child("size").setValue(size)
        child.child("condition").setValue(condition)
        child.child("userid").setValue(userID)
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
}