//
//  Image.swift
//  SwapIt
//
//  Created by Helena Leitão on 23/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

class Image {
    var image: NSData!
    var owner: String!
    
    init(image: NSData, owner: String) {
        self.image = image
        self.owner = owner
    }
}