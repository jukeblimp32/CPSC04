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
    var dateAvailable : String
    var numberOfRooms: String
    var bathroomNumber : String
    var monthRent: String
    var deposit : String
    var propertyID: Int
    var landlordID: String
    var milesToGU: String
    var houseImage: UIImage?
    var imageUrl: String
    var propertyType: String
    var pets : String
    var availability: String
    var description : String
    var leaseLength : String
    var counter: Int = 0
    var phoneNumber: String

    
    init(propertyID: Int, landlordID: String, address: String, dateAvailable : String, milesToGU: String, numberOfRooms: String, bathroomNumber: String, leaseLength : String, monthRent: String, deposit : String, houseImage : UIImage?, propertyType: String, pets: String, availability: String, description: String, phoneNumber: String) {
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
        self.imageUrl = ""
        self.pets = pets
        self.availability = availability
        self.description = description
        self.phoneNumber = phoneNumber
        if houseImage == nil {
            self.houseImage = UIImage(named: "default")
        }
        else {
            self.houseImage = houseImage
        }
    }
    
}
