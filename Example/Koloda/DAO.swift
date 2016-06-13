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
//        let child = self.rootRef.child("product").childByAutoId()
//        child.child("name").setValue("calça")
//        child.child("userid").setValue(userID)
    }
    
    func createAccount(name: String, username: String, password: String, callback: FIRAuthResultCallback) {
        FIRAuth.auth()?.createUserWithEmail(username, password: password, completion: callback)
    }
    
    func logOut() {
        try! FIRAuth.auth()!.signOut()
    }
}