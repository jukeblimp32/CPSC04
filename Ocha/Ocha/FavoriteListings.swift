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
    var dateAvailable : String
    var milesToGU: String
    var monthRent: String
    var deposit : String
    var numberOfRooms: String
    var bathroomNumber : String
    var leaseLength : String
    var propertyType: String
    var favoriteID: Int
    var userID: String
    var pets : String
    var availability: String
    var description : String
    var houseImage: UIImage?
    var imageUrl: String
    
    
    init(propertyID: Int, landlordID: String, address: String, dateAvailable : String, milesToGU: String, numberOfRooms: String, bathroomNumber: String, leaseLength : String, monthRent: String, deposit : String, houseImage : UIImage?, propertyType: String,pets : String, availability: String, description: String, favoriteID: Int, userID: String) {
        self.address = address
        self.dateAvailable = dateAvailable
        self.milesToGU = milesToGU
        self.propertyID = propertyID
        self.numberOfRooms = numberOfRooms
        self.bathroomNumber = bathroomNumber
        self.leaseLength = leaseLength
        self.monthRent = monthRent
        self.deposit = deposit
        self.landlordID = landlordID
        self.propertyType = propertyType
        self.favoriteID = favoriteID
        self.userID = userID
        self.pets = pets
        self.availability = availability
        self.description = description
        self.imageUrl = ""
        if houseImage == nil {
            self.houseImage = UIImage(named: "default")
        }
        else {
            self.houseImage = houseImage
        }
    }
    
}

