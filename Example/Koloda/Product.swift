//
//  Product.swift
//  Koloda
//
//  Created by Helena Leitão on 10/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class Product {
    var category: String!
    var subcategory: String!
    var description: String!
    var condition: String!
    var size: String!
    var brand: String!
    
    init(category: String, subcategory: String, description: String, condition: String, size: String, brand: String) {
        self.category = category
        self.subcategory = subcategory
        self.description = description
        self.condition = condition
        self.size = size
        self.brand = brand
    }
}