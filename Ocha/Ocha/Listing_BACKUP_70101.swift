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
    var numberOfRooms: String
    var monthRent: String
    var propertyID: Int
    var landlordID: String
    var milesToGU: String
    var houseImage: UIImage?

<<<<<<< HEAD
    
    init(propertyID: Int, landlordID: String, address: String, milesToGU: String, numberOfRooms: String, monthRent: String, houseImage : UIImage?) {
=======
    init(propertyID: Int, address: String, milesToGU: String, numberOfRooms: String, monthRent: String, houseImage : UIImage?) {
>>>>>>> 387e1b4f9565c56f57f813c6a7c34729320a0c4c
        self.address = address
        self.milesToGU = milesToGU
        self.propertyID = propertyID
        self.numberOfRooms = numberOfRooms
        self.monthRent = monthRent
        self.landlordID = landlordID
        if houseImage == nil {
            self.houseImage = UIImage(named: "default")
        }
        else {
            self.houseImage = houseImage
        }
    }
    
}
