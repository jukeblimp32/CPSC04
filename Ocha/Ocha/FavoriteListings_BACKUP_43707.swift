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
    var propertyType: String
    var favoriteID: Int
    var userID: String
    var pets : String
    var availability: String
    var description : String
    var houseImage: UIImage?
    var imageUrl: String
    var description: String
    var deposit: String
    var bathroom: String
    var date: String
    var lease: String
    var pets: String
    
    
<<<<<<< HEAD
    init(propertyID: Int, landlordID: String, address: String, milesToGU: String, numberOfRooms: String, monthRent: String, houseImage : UIImage?, propertyType: String, available: String, description: String, deposit: String,bathroom: String, date: String, lease: String, pets: String, favoriteID: Int, userID: String ) {
=======
    init(propertyID: Int, landlordID: String, address: String, dateAvailable : String, milesToGU: String, numberOfRooms: String, bathroomNumber: String, monthRent: String, deposit : String, houseImage : UIImage?, propertyType: String,pets : String, availability: String, description: String, favoriteID: Int, userID: String) {
>>>>>>> 36b6adec5a1d22a475ea38d01aa026ec974f47d8
        self.address = address
        self.dateAvailable = dateAvailable
        self.milesToGU = milesToGU
        self.propertyID = propertyID
        self.numberOfRooms = numberOfRooms
        self.bathroomNumber = bathroomNumber
        self.monthRent = monthRent
        self.deposit = deposit
        self.landlordID = landlordID
        self.propertyType = propertyType
        self.favoriteID = favoriteID
        self.userID = userID
<<<<<<< HEAD
        self.description = description
        self.deposit = deposit
        self.bathroom = bathroom
        self.date = date
        self.lease = lease
        self.pets = pets
=======
        self.pets = pets
        self.availability = availability
        self.description = description
>>>>>>> 36b6adec5a1d22a475ea38d01aa026ec974f47d8
        self.imageUrl = ""
        if houseImage == nil {
            self.houseImage = UIImage(named: "default")
        }
        else {
            self.houseImage = houseImage
        }
    }
    
}

