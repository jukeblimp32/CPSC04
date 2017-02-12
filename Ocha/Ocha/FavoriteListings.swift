//
//  FavoriteListings.swift
//  Ocha
//
//  Created by Herrera Ramirez, Elma on 2/8/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit

class FavoriteListings {
    var propertyID: Int
    var landlordID: String
    var address: String
    var milesToGU: String
    var monthRent: String
    var numberOfRooms: String
    var propertyType: String
    var available: String
    var favoriteID: Int
    var userID: String
    var houseImage: UIImage?
    var imageUrl: String
    var description: String
    var deposit: String
    var bathroom: String
    var date: String
    var lease: String
    var pets: String
    
    
    init(propertyID: Int, landlordID: String, address: String, milesToGU: String, numberOfRooms: String, monthRent: String, houseImage : UIImage?, propertyType: String, available: String, description: String, deposit: String,bathroom: String, date: String, lease: String, pets: String, favoriteID: Int, userID: String ) {
        self.address = address
        self.milesToGU = milesToGU
        self.propertyID = propertyID
        self.numberOfRooms = numberOfRooms
        self.monthRent = monthRent
        self.landlordID = landlordID
        self.propertyType = propertyType
        self.available = available
        self.favoriteID = favoriteID
        self.userID = userID
        self.description = description
        self.deposit = deposit
        self.bathroom = bathroom
        self.date = date
        self.lease = lease
        self.pets = pets
        self.imageUrl = ""
        if houseImage == nil {
            self.houseImage = UIImage(named: "default")
        }
        else {
            self.houseImage = houseImage
        }
    }
    
}

