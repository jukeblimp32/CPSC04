//
//  Review.swift
//  Ocha
//
//  Created by Talkov, Leah C on 3/22/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit

class Review {
    var propertyID: Int
    var landlordResponse: String
    var location : String
    var space: String
    var priceValue : String
    var quality: String
    var reviewNum: Int
    var email: String
    var date: String

    
    init(propertyID: Int, reviewNum: Int, email: String, date: String, landlordResponse : String, location : String, priceValue : String, space : String, quality : String) {
        self.reviewNum = reviewNum
        self.propertyID = propertyID
        self.landlordResponse = landlordResponse
        self.location = location
        self.space = space
        self.priceValue = priceValue
        self.quality = quality
        self.email = email
        self.date = date
    }
}
