//
//  ListingPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class LandlordListingPage: UITableViewController {
    
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
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var propertyImage: UIImageView!
    @IBOutlet var dateAvailableLabel: UILabel!
    @IBOutlet var availabilityLabel: UILabel!
    @IBOutlet var rentLabel: UILabel!
    @IBOutlet var depositLabel: UILabel!
    @IBOutlet var bathroomLabel: UILabel!
    @IBOutlet var bedroomLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!

    @IBOutlet var petsLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var leaseLabel: UILabel!
    @IBOutlet weak var toHomePageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "EditListing",
            //Sets the page to be loaded as ListingPage
            let destination = segue.destination as? EditListing
            //Gets the selected cell index
            //Setting the variables in the listing class to the cell info
        {
            destination.address = address
            destination.rent = rent
            destination.bedroomNum = rooms
            destination.distance = distance
            destination.imageURL = imageUrl
           // destination.image = propertyImage.image!
            destination.propertyID = propertyID
            destination.leaseTerms = leaseLength
            destination.dateAvailable = dateAvailable
            destination.bathroomNum = bathroomNumber
            destination.deposit = deposit
            destination.pets = pets
            destination.availability = availability
            destination.propDescription = propDescription
            destination.phoneNumber = phoneNumber
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
