//
//  ListingPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class FavoriteListingPage: UITableViewController {
    
    var imageUrl = ""
    var address : String = ""
    var distance : String = ""
    var rooms : String = ""
    var rent : String = ""
    var phoneNumber : String = ""
    var dateAvailable : String = ""
    var deposit : String = ""
    var bathroomNumber : String = ""
    var leaseLength : String = ""
    var propertyType: String = ""
    var pets : String = ""
    var availability: String = ""
    var propDescription : String = ""
    var propertyID : Int = 0
    var image : UIImage = UIImage(named: "default")!
    
    @IBOutlet var propertyImage: UIImageView!
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var availabilityLabel: UILabel!
    @IBOutlet var rentLabel: UILabel!
    @IBOutlet var depositLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var petsLabel: UILabel!
    @IBOutlet var leaseLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var bathroomLabel: UILabel!
    @IBOutlet var bedroomLabel: UILabel!
    @IBOutlet var dateAvailableLabel: UILabel!
    
    @IBOutlet weak var toHomePageButton: UIButton!
    
    override func viewDidLoad() {
        addressLabel.text = address
        dateAvailableLabel.text = "Date Available: " + dateAvailable
        availabilityLabel.text = "Availability: " + availability
        depositLabel.text = "Deposit: " + deposit
        bedroomLabel.text = "Bedrooms: " + rooms
        bathroomLabel.text = "Bathrooms: " + bathroomNumber
        distanceLabel.text = "Distance from Gonzaga: " + distance + " mile(s)"
        phoneLabel.text = "Phone Number: " + phoneNumber
        petsLabel.text = "Pets allowed: " + pets
        leaseLabel.text = "Lease Terms: " + leaseLength
        descriptionField.text = propDescription
        rentLabel.text = "Rent: " + rent
        propertyImage.loadCachedImages(url: imageUrl)
        super.viewDidLoad()
        
    }
    
  override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
