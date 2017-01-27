//
//  Filters.swift
//  Ocha
//
//  Created by Herrera Ramirez, Elma on 1/26/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit

class Filters {
    var propertyID: Int
    var numberOfRooms: String
    var monthRent: String
    var milesToGU: String
    var propertyType: String
    
    init(propertyID: Int, numberOfRooms: String, monthRent: String, milesToGU: String, propertyType: String) {
        self.propertyID = propertyID
        self.numberOfRooms = numberOfRooms
        self.monthRent = monthRent
        self.milesToGU = milesToGU
        self.propertyType = propertyType
    }
    
}

