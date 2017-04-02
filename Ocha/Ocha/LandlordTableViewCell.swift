//
//  LandlordTableViewCell.swift
//  Ocha
//
//  Created by Taylor, Scott A on 3/11/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class LandlordTableViewCell: UITableViewCell {
    // MARK: Properties
    
    let createFavorites = "http://147.222.165.203/MyWebService/api/CreateFavorite.php"
    let removeFavorites = "http://147.222.165.203/MyWebService/api/RemoveFavorites.php"
    
    let propertyAddress = UILabel()
    let propertyDistance = UILabel()
    let propertyRent = UILabel()
    let propertyRooms = UILabel()
    let propertyImage = UIImageView()
    let propertyStatus = UILabel()
    let favoriteButton = UIButton()
    let rentLabel = UILabel()
    let roomLabel = UILabel()
    let distanceLabel = UILabel()
    let statusLabel = UILabel()
    var listing = Listing(propertyID: 0, landlordID: "", address: "", dateAvailable: "", milesToGU: "", numberOfRooms: "", bathroomNumber: "", leaseLength: "", monthRent: "", deposit: "", houseImage: nil, propertyType: "", pets: "", availability: "", description: "", phoneNumber: "", email : "", userID : "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenSize = UIScreen.main.bounds
        
        propertyAddress.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyAddress.textColor = UIColor.black
        propertyAddress.frame = CGRect(x: (screenSize.width) * (6/100) , y: (self.frame.height) * (5/100), width: self.frame.width * (60/100) , height: 20)
        propertyAddress.adjustsFontSizeToFitWidth = true
        self.addSubview(propertyAddress)
        
        propertyImage.frame = CGRect(x: (screenSize.width * (6/100)), y: (self.frame.height) * (20/100), width: self.frame.width * (25/100) , height: self.frame.height * (60/100))
        self.addSubview(propertyImage)
        
        propertyRent.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyRent.textColor = UIColor.black
        propertyRent.adjustsFontSizeToFitWidth = true
        propertyRent.frame = CGRect(x: (screenSize.width) * (80/100), y: (self.frame.height) * (20/100), width: self.frame.width * (18/100), height: 20)
        self.addSubview(propertyRent)
        
        propertyRooms.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyRooms.textColor = UIColor.black
        propertyRooms.adjustsFontSizeToFitWidth = true
        propertyRooms.frame = CGRect(x: (screenSize.width) * (80/100), y: (self.frame.height) * (35/100), width: self.frame.width * (18/100), height: 15)
        self.addSubview(propertyRooms)
        
        propertyDistance.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyDistance.textColor = UIColor.black
        propertyDistance.adjustsFontSizeToFitWidth = true
        propertyDistance.frame = CGRect(x: (screenSize.width) * (80/100), y: (self.frame.height) * (50/100), width: self.frame.width * (18/100), height: 15)
        self.addSubview(propertyDistance)
        
        
        propertyStatus.font = UIFont(name: propertyStatus.font.fontName, size: 15)
        propertyStatus.textColor = UIColor.darkGray
        propertyStatus.adjustsFontSizeToFitWidth = true
        propertyStatus.frame = CGRect(x: (screenSize.width) * (80/100), y: (self.frame.height) * (75/100), width: self.frame.width * (18/100), height: 15)
        self.addSubview(propertyStatus)
        
        
        rentLabel.text = "Rent per Month:"
        rentLabel.font = UIFont(name: propertyRent.font.fontName, size: 15)
        rentLabel.textColor = UIColor.black
        rentLabel.adjustsFontSizeToFitWidth = true
        rentLabel.frame = CGRect(x: (screenSize.width) * (38/100), y: (self.frame.height) * (20/100), width: screenSize.width * (42/100), height: 15)
        self.addSubview(rentLabel)
        
        roomLabel.text = "Bedrooms:"
        roomLabel.font = UIFont(name: propertyRent.font.fontName, size: 15)
        roomLabel.textColor = UIColor.black
        roomLabel.adjustsFontSizeToFitWidth = true
        roomLabel.frame = CGRect(x: (screenSize.width) * (38/100), y: (self.frame.height) * (35/100), width: screenSize.width * (42/100), height: 15)
        self.addSubview(roomLabel)
        
        distanceLabel.text = "Miles to GU:"
        distanceLabel.font = UIFont(name: propertyRent.font.fontName, size: 15)
        propertyAddress.adjustsFontSizeToFitWidth = true
        distanceLabel.textColor = UIColor.black
        distanceLabel.frame = CGRect(x: (screenSize.width) * (38/100), y: (self.frame.height) * (50/100) , width: screenSize.width * (42/100), height: 15)
        self.addSubview(distanceLabel)
        
        statusLabel.text = "STATUS:"
        statusLabel.font = UIFont(name: statusLabel.font.fontName, size: 12)
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.textColor = UIColor.darkGray
        statusLabel.frame = CGRect(x: (screenSize.width) * (38/100), y: (self.frame.height) * (75/100) , width: screenSize.width * (42/100), height: 15)
        self.addSubview(statusLabel)
    }
    
    
    func starPressed(_ sender : UIButton) {
        if (sender.isSelected){
            sender.isSelected = false
            removeFavorite()
        }
        else
        {
            sender.isSelected = true
            createFavorite()
        }
    }
    
    func createFavorite(){
        //created NSURL
        let saveRequestURL = NSURL(string: createFavorites)
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields
        
        //let landlordID = self.firstName
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        
        //post parameter
        //concatenating keys and values from text field
        let propID = listing.propertyID
        let userID = uid
        let postParameters="property_id="+String(propID)+"&user_id="+userID!;
        
        
        //adding parameters to request body
        saveRequest.httpBody=postParameters.data(using: String.Encoding.utf8)
        //task to send to post request
        let saveTask=URLSession.shared.dataTask(with: saveRequest as URLRequest){
            data,response, error in
            if error != nil{
                print("error is \(error)")
                return;
            }
            do{
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = myJSON{
                    var msg:String!
                    msg = parseJSON["message"]as! String?
                    print(msg)
                }
            }catch{
                print(error)
            }
        }
        saveTask.resume()
    }
    
    func removeFavorite(){
        //created NSURL
        let saveRequestURL = NSURL(string: removeFavorites)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields
        
        //let landlordID = self.firstName
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        //post parameter
        //concatenating keys and values from text field
        let propID = listing.propertyID
        let userID = uid
        let postParameters="property_id="+String(propID)+"&user_id="+userID!;
        
        //adding parameters to request body
        saveRequest.httpBody=postParameters.data(using: String.Encoding.utf8)
        //task to send to post request
        let saveTask=URLSession.shared.dataTask(with: saveRequest as URLRequest){
            data,response, error in
            if error != nil{
                print("error is \(error)")
                return;
            }
            do{
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJSON = myJSON{
                    var msg:String!
                    msg = parseJSON["message"]as! String?
                    print(msg)
                }
            }catch{
                print(error)
            }
        }
        saveTask.resume()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}

