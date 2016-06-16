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
   
    // Referência para o Realtime Database
    let rootRef = FIRDatabase.database().reference()
    
    // Referência para o Storage
    let storage = FIRStorage.storage()
    
    // registra o usuário no realtime database usando o id do authorization
    func registerUser(name: String, userID: String) {
        self.rootRef.child("profile").child(userID).setValue(["name": name])
    }
    
    // função recebe tipo do produto (blusa, vestido, calça, etc) e id do usuário dono
    func registerProduct(type: String, userID: String) { // bottom, top, footwear
        let child = self.rootRef.child("product").childByAutoId()
//        child.child("department").child("women").child("top")
//        child.child("description").setValue("bla bla bla calça legal")
//        child.child("brand").setValue("C&A")
//        child.child("size").setValue("M")
//        child.child("condition").setValue("never used")
        child.child("type").setValue(type)
        child.child("userid").setValue(userID)
    }
    
    func createAccount(name: String, username: String, password: String, callback: FIRAuthResultCallback) {
        FIRAuth.auth()?.createUserWithEmail(username, password: password, completion: callback)
    }
    
    func login(username: String, password: String, callback:FIRAuthResultCallback) {
        FIRAuth.auth()?.signInWithEmail(username, password: password, completion:callback)
    }

    func logout() {
        try! FIRAuth.auth()!.signOut()
    }
}