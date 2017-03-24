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
    var noise : String
    var space: String
    var priceValue : String
    var quality: String

    
    init(propertyID: Int, landlordResponse : String, noise : String, priceValue : String, space : String, quality : String) {
        self.propertyID = propertyID
        self.landlordResponse = landlordResponse
        self.noise = noise
        self.space = space
        self.priceValue = priceValue
        self.quality = quality
    }
}
