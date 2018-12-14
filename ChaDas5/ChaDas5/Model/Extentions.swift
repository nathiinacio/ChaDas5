//
//  Extentions.swift
//  ChaDas5
//
//  Created by Julia Rocha on 10/12/18.
//  Copyright © 2018 Julia Maria Santos. All rights reserved.
//

import Foundation

extension Date {
    var keyString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH_mm_ss"
        return dateFormatter.string(from: self)
    }
}

