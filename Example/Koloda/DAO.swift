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
    
    let storage = FIRStorage.storage()
    
    func login(username: String, password: String) {
        FIRAuth.auth()?.signInWithEmail(username, password: password, completion: {
            user, error in
            if error != nil {
                print("############ Erro: \(error)")
            } else {
                print("User logged in!")
            }
        })
    }
    
    func createAccount(username: String, password: String) {
        FIRAuth.auth()?.createUserWithEmail(username, password: password, completion: {
            user, error in
            if error != nil {
                self.login(username, password: password)
            } else {
                print("User created")
                self.login(username, password: password)
            }
        })
        
    }
    
    func logOut() {
        try! FIRAuth.auth()!.signOut()
    }
}