//
//  Extensions.swift
//  SwapIt
//
//  Created by Helena Leitão on 23/06/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension NSDate {
    func getCurrentShortDate() -> String {
        let todaysDate = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        let DateInFormat = dateFormatter.stringFromDate(todaysDate)
        
        return DateInFormat
    }
}

