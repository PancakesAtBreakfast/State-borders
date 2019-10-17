//
//  State.swift
//  State Borders
//
//  Created by Niso on 10/16/19.
//  Copyright © 2019 Niso. All rights reserved.
//

import Foundation

struct State {
    var name: String
    var nativeName: String
    var area: Double
    var borders: NSArray
    
    init(_ json: NSDictionary) {
        self.name = json.value(forKey: "name") as? String ?? ""
        self.nativeName = json.value(forKey: "nativeName") as? String ?? ""
        self.area = json.value(forKey: "area") as? Double ?? 0.0
        self.borders = json.value(forKey: "borders") as? NSArray ?? []
    }
    
    init(name: String, nativeName: String, area: Double, borders: NSArray) {
        self.name = name
        self.nativeName = nativeName
        self.area = area
        self.borders = borders
    }
}
