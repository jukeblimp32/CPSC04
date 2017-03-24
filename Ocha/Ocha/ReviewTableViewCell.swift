//
//  ReviewTableViewCell.swift
//  Ocha
//
//  Created by Talkov, Leah C on 3/22/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet var propertyImage: UIImageView!
    @IBOutlet var propertyDistance: UILabel!
    @IBOutlet var propertyRent: UILabel!
    @IBOutlet var propertyAddress: UILabel!
    @IBOutlet var propertyRooms: UILabel!
    
    var listing = Listing(propertyID: 0, landlordID: "", address: "", dateAvailable: "", milesToGU: "", numberOfRooms: "", bathroomNumber: "", leaseLength: "", monthRent: "", deposit: "", houseImage: nil, propertyType: "", pets: "", availability: "", description: "", phoneNumber: "", email : "", userID : "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        propertyDistance.adjustsFontSizeToFitWidth = true
        propertyRent.adjustsFontSizeToFitWidth = true
        propertyAddress.adjustsFontSizeToFitWidth = true
        propertyRooms.adjustsFontSizeToFitWidth = true
    }
    
    
}
