//
//  ListingTableViewCell.swift
//  Ocha
//
//  Created by Taylor, Scott A on 11/18/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell {
    // MARK: Properties
    
    let propertyAddress = UILabel()
    let propertyDistance = UILabel()
    let propertyRent = UILabel()
    let propertyRooms = UILabel()
    let propertyImage = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenSize: CGRect = UIScreen.main.bounds
        
        propertyAddress.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyAddress.textColor = UIColor.black
        propertyAddress.frame = CGRect(x: (self.frame.width) * (5/100) , y: (self.frame.height) * (10/100), width: self.frame.width * (90/100) , height: 15)
        propertyAddress.adjustsFontSizeToFitWidth = true
        self.addSubview(propertyAddress)
        
        propertyImage.frame = CGRect(x: (self.frame.width) * (5/100) , y: (self.frame.height) * (20/100), width: self.frame.width * (35/100) , height: self.frame.height * (75/100))
        self.addSubview(propertyImage)
        
        
        propertyRent.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyRent.textColor = UIColor.black
        propertyRent.frame = CGRect(x: (self.frame.width) * (80/100), y: (self.frame.height) * (40/100), width: self.frame.width * (15/100), height: 15)
        self.addSubview(propertyRent)
        
        propertyRooms.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyRooms.textColor = UIColor.black
        propertyRooms.frame = CGRect(x: (self.frame.width) * (80/100), y: (self.frame.height) * (60/100), width: self.frame.width * (15/100), height: 15)
        self.addSubview(propertyRooms)
        
        propertyDistance.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyDistance.textColor = UIColor.black
        propertyDistance.frame = CGRect(x: (self.frame.width) * (80/100), y: (self.frame.height) * (80/100), width: self.frame.width * (15/100), height: 15)
        self.addSubview(propertyDistance)
        
        let rentLabel = UILabel()
        rentLabel.text = "Rent per Month:"
        rentLabel.font = UIFont(name: propertyRent.font.fontName, size: 15)
        rentLabel.textColor = UIColor.black
        rentLabel.adjustsFontSizeToFitWidth = true
        rentLabel.frame = CGRect(x: (self.frame.width) * (45/100), y: (self.frame.height) * (40/100), width: self.frame.width * (35/100), height: 15)
        self.addSubview(rentLabel)
        
        let roomLabel = UILabel()
        roomLabel.text = "Bedrooms:"
        roomLabel.font = UIFont(name: propertyRent.font.fontName, size: 15)
        roomLabel.textColor = UIColor.black
        roomLabel.frame = CGRect(x: (self.frame.width) * (45/100), y: (self.frame.height) * (60/100), width: self.frame.width * (35/100), height: 15)
        self.addSubview(roomLabel)
        
        let distanceLabel = UILabel()
        distanceLabel.text = "Miles to GU:"
        distanceLabel.font = UIFont(name: propertyRent.font.fontName, size: 15)
        distanceLabel.textColor = UIColor.black
        distanceLabel.frame = CGRect(x: (screenSize.width) * (55/100), y: (self.frame.height) * (70/100) , width: screenSize.width * (25/100), height: 15)
        self.addSubview(distanceLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
