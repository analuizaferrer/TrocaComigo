//
//  Product.swift
//  Koloda
//
//  Created by Helena Leitão on 10/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class Product {
    var id : String?
    var category: String!
    var subcategory: String!
    var description: String!
    var condition: String!
    var size: String!
    var brand: String!
    var images: [NSData]?
    
    init(category: String, subcategory: String, description: String, condition: String, size: String, brand: String, images: [NSData]) {
        self.category = category
        self.subcategory = subcategory
        self.description = description
        self.condition = condition
        self.size = size
        self.brand = brand
        self.images = images
    }
    
    init(dict : [String : AnyObject], index : String) {
        self.id = index
        self.category = CategoryType.RawValue()
        self.subcategory = SubcategoryType.RawValue()
        self.description = dict["description"] as! String
        self.condition = dict["condition"] as! String
        self.size = dict["size"] as! String
        self.brand = dict["brand"] as! String
    }
}

enum CategoryType : String {
    case Women = "women"
    case Men = "men"
    case Kids = "kids"
}

enum SubcategoryType: String {
    case Top = "top"
    case Bottom = "bottom"
    case OnePiece = "one piece"
    case Bags = "bags"
    case Footwear = "footwear"
    case Accessories = "accessories"
}