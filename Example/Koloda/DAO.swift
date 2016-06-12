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
   
    let rootRef = FIRDatabase.database().reference()
    
    func login(username: String, password: String, callback:FIRAuthResultCallback) {
        FIRAuth.auth()?.signInWithEmail(username, password: password, completion:callback)
    }
    
    func registerUser(name: String, userID: String) {
        self.rootRef.child("profile").child(userID).setValue(["name": name])
    }
    
    func createAccount(name: String, username: String, password: String) {
        FIRAuth.auth()?.createUserWithEmail(username, password: password, completion: {
            user, error in
            if error != nil {
                //self.login(username, password: password)
            } else {
                print("User created")
                self.registerUser(name, userID: (user?.uid)!)
            }
        })
    }
    
    func logOut() {
        try! FIRAuth.auth()!.signOut()
    }
}