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
    let favoriteButton = UIButton()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenSize = UIScreen.main.bounds
        
        propertyAddress.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyAddress.textColor = UIColor.black
        propertyAddress.frame = CGRect(x: (screenSize.width) * (6/100) , y: (self.frame.height) * (10/100), width: self.frame.width * (60/100) , height: 15)
        propertyAddress.adjustsFontSizeToFitWidth = true
        self.addSubview(propertyAddress)
        
        propertyImage.frame = CGRect(x: (screenSize.width * (6/100)), y: (self.frame.height) * (20/100), width: self.frame.width * (25/100) , height: self.frame.height * (60/100))
        self.addSubview(propertyImage)
        
        //let image = UIImage(named: "emptyStar") as UIImage?
        favoriteButton.backgroundColor = UIColor.white
        favoriteButton.frame = CGRect(x: (screenSize.width) * (68/100), y: (self.frame.height) * (4/100), width: self.frame.width * (10/100), height: 40)
        //favoriteButton.setImage(image, for: .normal)
        favoriteButton.addTarget(self, action: #selector(ListingTableViewCell.starPressed(_:)), for:UIControlEvents.touchUpInside)
        self.addSubview(favoriteButton)
        
        propertyRent.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyRent.textColor = UIColor.black
        propertyRent.adjustsFontSizeToFitWidth = true
        propertyRent.frame = CGRect(x: (screenSize.width) * (68/100), y: (self.frame.height) * (30/100), width: self.frame.width * (18/100), height: 15)
        self.addSubview(propertyRent)
        
        propertyRooms.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyRooms.textColor = UIColor.black
        propertyRooms.adjustsFontSizeToFitWidth = true
        propertyRooms.frame = CGRect(x: (screenSize.width) * (68/100), y: (self.frame.height) * (50/100), width: self.frame.width * (18/100), height: 15)
        self.addSubview(propertyRooms)
        
        propertyDistance.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyDistance.textColor = UIColor.black
        propertyDistance.adjustsFontSizeToFitWidth = true
        propertyDistance.frame = CGRect(x: (screenSize.width) * (68/100), y: (self.frame.height) * (70/100), width: self.frame.width * (18/100), height: 15)
        self.addSubview(propertyDistance)
        
        let rentLabel = UILabel()
        rentLabel.text = "Rent per Month:"
        rentLabel.font = UIFont(name: propertyRent.font.fontName, size: 15)
        rentLabel.textColor = UIColor.black
        rentLabel.adjustsFontSizeToFitWidth = true
        rentLabel.frame = CGRect(x: (screenSize.width) * (38/100), y: (self.frame.height) * (30/100), width: screenSize.width * (30/100), height: 15)
        self.addSubview(rentLabel)
        
        let roomLabel = UILabel()
        roomLabel.text = "Bedrooms:"
        roomLabel.font = UIFont(name: propertyRent.font.fontName, size: 15)
        roomLabel.textColor = UIColor.black
        roomLabel.adjustsFontSizeToFitWidth = true
        roomLabel.frame = CGRect(x: (screenSize.width) * (38/100), y: (self.frame.height) * (50/100), width: screenSize.width * (30/100), height: 15)
        self.addSubview(roomLabel)
        
        let distanceLabel = UILabel()
        distanceLabel.text = "Miles to GU:"
        distanceLabel.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyAddress.adjustsFontSizeToFitWidth = true
        distanceLabel.textColor = UIColor.black
        distanceLabel.frame = CGRect(x: (screenSize.width) * (38/100), y: (self.frame.height) * (70/100) , width: screenSize.width * (30/100), height: 15)
        self.addSubview(distanceLabel)
    }

    
    func starPressed(_ sender : UIButton) {
        if (sender.isSelected){
            sender.isSelected = false
        }
        else
        {
            sender.isSelected = true
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
