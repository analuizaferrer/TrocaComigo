//
//  User.swift
//  Koloda
//
//  Created by Helena Leitão on 10/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class User {
    var id: String!
    var name: String!
    var location: String!
    var womenPreference: Bool!
    var menPreference: Bool!
    var kidsPreference: Bool!
    var profilePic: UIImage?
    var products = [Product]()
    
    static let singleton = User()
    
    private init() {
        
    }
    
//    init(dict : [String : AnyObject]) {
//        self.name = dict["name"] as! String
//        self.location = dict["location"] as! String
//        self.womenPreference = true
//        self.menPreference = true
//        self.kidsPreference = true
//    }
}