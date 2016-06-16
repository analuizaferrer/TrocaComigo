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
    
    // função registra infos do produto e id do usuário dono
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