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
    
    // função recebe tipo do produto (blusa, vestido, calça, etc) e id do usuário dono
    func registerProduct(type: String, userID: String) {
        let child = self.rootRef.child("product").childByAutoId()
        child.child("type").setValue(type)
        child.child("userid").setValue(userID)
    }
    
    func createAccount(name: String, username: String, password: String, callback: FIRAuthResultCallback) {
        FIRAuth.auth()?.createUserWithEmail(username, password: password, completion: callback)
    }
    
    func logOut() {
        try! FIRAuth.auth()!.signOut()
    }
}