//
//  Listing.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//
import UIKit

class Listing {
    var address: String
    var numberOfRooms: Int
    var monthRent: Int
    var propertyID: String
    var milesToGU: Float
    var houseImage: UIImage?

    
    init(propertyID: String, address: String, milesToGU: Float, numberOfRooms: Int, monthRent: Int, houseImage : UIImage?) {
        self.address = address
        self.milesToGU = milesToGU
        self.propertyID = propertyID
        self.numberOfRooms = numberOfRooms
        self.monthRent = monthRent
        if houseImage == nil {
            self.houseImage = UIImage(named: "default")
        }
        else {
            self.houseImage = houseImage
        }
    }
    
}
