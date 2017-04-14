//
//  ListingTableViewCell.swift
//  Ocha
//
//  Created by Taylor, Scott A on 11/18/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class ListingTableViewCell: UITableViewCell {
    // MARK: Properties
    
    let createFavorites = "http://147.222.165.203/MyWebService/api/CreateFavorite.php"
    let removeFavorites = "http://147.222.165.203/MyWebService/api/RemoveFavorites.php"
    
    let propertyAddress = UILabel()
    let propertyDistance = UILabel()
    let propertyRent = UILabel()
    let propertyRooms = UILabel()
    let propertyImage = UIImageView()
    let favoriteButton = UIButton()
    let rentLabel = UILabel()
    let roomLabel = UILabel()
    let distanceLabel = UILabel()
    var listing = Listing(propertyID: 0, landlordID: "", address: "", dateAvailable: "", milesToGU: "", numberOfRooms: "", bathroomNumber: "", leaseLength: "", monthRent: "", deposit: "", houseImage: nil, propertyType: "", pets: "", availability: "", description: "", phoneNumber: "", email : "", userID : "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenSize = UIScreen.main.bounds
        
        // Get a scale based on iPhone 5
        let screenScale = screenSize.height / 568.0
        let cellSize = (screenSize.height * (80.0/100))/4
        
        propertyAddress.font = UIFont.systemFont(ofSize: 15 * screenScale)
        propertyAddress.textColor = UIColor.black
        propertyAddress.frame = CGRect(x: (screenSize.width) * (6/100) , y: cellSize * (7/100), width: self.frame.width * (60/100) , height: 15 * screenScale)
        propertyAddress.adjustsFontSizeToFitWidth = true
        self.addSubview(propertyAddress)
        
        propertyImage.frame = CGRect(x: (screenSize.width * (6/100)), y: cellSize * (30/100), width: screenSize.width * (30/100) , height: cellSize * (75/100))
        propertyImage.clipsToBounds = true
        propertyImage.contentMode = .scaleAspectFit
        self.addSubview(propertyImage)
        
        //let image = UIImage(named: "emptyStar") as UIImage?
        favoriteButton.backgroundColor = UIColor.white
        favoriteButton.frame = CGRect(x: (screenSize.width) * (80/100), y: cellSize * (4/100), width: self.frame.width * (10/100), height: 30)
        //favoriteButton.setImage(image, for: .normal)
        favoriteButton.addTarget(self, action: #selector(ListingTableViewCell.starPressed(_:)), for:UIControlEvents.touchUpInside)
        self.addSubview(favoriteButton)
        
        propertyRent.font = UIFont.systemFont(ofSize: 15 * screenScale)
        propertyRent.textColor = UIColor.black
        propertyRent.adjustsFontSizeToFitWidth = true
        propertyRent.frame = CGRect(x: (screenSize.width) * (80/100), y: cellSize * (30/100), width: self.frame.width * (18/100), height: 15 * screenScale)
        self.addSubview(propertyRent)
        
        propertyRooms.font = UIFont.systemFont(ofSize: 15 * screenScale)
        propertyRooms.textColor = UIColor.black
        propertyRooms.adjustsFontSizeToFitWidth = true
        propertyRooms.frame = CGRect(x: (screenSize.width) * (80/100), y: cellSize * (60/100), width: self.frame.width * (18/100), height: 15 * screenScale)
        self.addSubview(propertyRooms)
        
        propertyDistance.font = UIFont.systemFont(ofSize: 15 * screenScale)
        propertyDistance.textColor = UIColor.black
        propertyDistance.adjustsFontSizeToFitWidth = true
        propertyDistance.frame = CGRect(x: (screenSize.width) * (80/100), y: cellSize * (90/100), width: self.frame.width * (18/100), height: 15 * screenScale)
        self.addSubview(propertyDistance)
        
        rentLabel.text = "Rent per Month:"
        rentLabel.font = UIFont.systemFont(ofSize: 15 * screenScale)
        rentLabel.textColor = UIColor.black
        rentLabel.adjustsFontSizeToFitWidth = true
        rentLabel.frame = CGRect(x: (screenSize.width) * (38/100), y: cellSize * (30/100), width: screenSize.width * (42/100), height: 15)
        rentLabel.sizeToFit()
        self.addSubview(rentLabel)
    
        roomLabel.text = "Bedrooms:"
        roomLabel.font = UIFont.systemFont(ofSize: 15 * screenScale)
        roomLabel.textColor = UIColor.black
        roomLabel.adjustsFontSizeToFitWidth = true
        roomLabel.frame = CGRect(x: (screenSize.width) * (38/100), y: cellSize * (60/100), width: screenSize.width * (42/100), height: 15)
        roomLabel.sizeToFit()
        self.addSubview(roomLabel)
        
        distanceLabel.text = "Miles to GU:"
        distanceLabel.font = UIFont.systemFont(ofSize: 15 * screenScale)
        propertyAddress.adjustsFontSizeToFitWidth = true
        distanceLabel.textColor = UIColor.black
        distanceLabel.frame = CGRect(x: (screenSize.width) * (38/100), y: cellSize * (90/100) , width: screenSize.width * (42/100), height: 15)
        distanceLabel.sizeToFit()
        self.addSubview(distanceLabel)
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
