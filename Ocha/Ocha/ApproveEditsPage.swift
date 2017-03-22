//
//  ApproveEditsPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class ApproveEditsPage: UITableViewController {
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
    var email : String = ""
    var propertyID : Int = 0
    var image : UIImage = UIImage(named: "default")!
    
    var listing = Listing(propertyID: 0, landlordID: "", address: "", dateAvailable: "", milesToGU: "", numberOfRooms: "", bathroomNumber: "", leaseLength: "", monthRent: "", deposit: "", houseImage: nil, propertyType: "", pets: "", availability: "", description: "", phoneNumber: "", email : "", userID : "")
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var propertyImage: UIImageView!
    @IBOutlet var dateAvailableLabel: UILabel!
    @IBOutlet var rentLabel: UILabel!
    @IBOutlet var bedroomLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    
    @IBOutlet var petsLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var leaseLabel: UILabel!
    @IBOutlet weak var toHomePageButton: UIButton!
    @IBOutlet weak var toHomePageButton1: UIButton!
    
    
    let URL_APPROVE_EDIT = "http://147.222.165.203/MyWebService/api/approveEdits.php"
    let URL_REJECT_EDIT = "http://147.222.165.203/MyWebService/api/rejectEdits.php"
    let statusChange = "http://147.222.165.203/MyWebService/api/statusChange.php"
    let getProperties = "http://147.222.165.203/MyWebService/api/DisplayProperties.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findOriginalListing()
        addressLabel.text = address
        distanceLabel.text = "Distance from Gonzaga: " + distance + " mile(s)"
        phoneLabel.text = "Phone Number: " + phoneNumber
        petsLabel.text = "Pets allowed: " + pets
        leaseLabel.text = "Lease Terms: " + leaseLength
        descriptionField.text = propDescription
        rentLabel.text = "Rent: " + rent
        emailLabel.text = "Email: " + email
        dateAvailableLabel.text = "Date Available: " + dateAvailable + "          Availability: " + availability
        bedroomLabel.text = "Bedrooms: " + rooms + "          Bathrooms: " + bathroomNumber
        rentLabel.text = "Rent: " + rent + "          Deposit: " + deposit
        dateAvailableLabel.adjustsFontSizeToFitWidth = true
        bedroomLabel.adjustsFontSizeToFitWidth = true
        rentLabel.adjustsFontSizeToFitWidth = true
        emailLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.adjustsFontSizeToFitWidth = true
        phoneLabel.adjustsFontSizeToFitWidth = true
        petsLabel.adjustsFontSizeToFitWidth = true
        leaseLabel.adjustsFontSizeToFitWidth = true
        propertyImage.loadCachedImages(url: imageUrl)
    }
    
    func findOriginalListing(){
        var tempListings = [(Int, Listing)]()
        //create NSURL
        let getRequestURL = NSURL(string: getProperties)
        //creating NSMutableURLRequest
        let getRequest = NSMutableURLRequest(url:getRequestURL! as URL)
        //setting the method to GET
        getRequest.httpMethod = "GET"
        //task to be sent to the GET request
        let getTask = URLSession.shared.dataTask(with: getRequest as URLRequest) {
            data, response,error in
            //If there is an error in connecting with the database, print error
            if error != nil {
                print("error is \(error)")
                return;
            }
            do {
                //converting response to dictionary
                var propertyJSON : NSDictionary!
                propertyJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //Getting the properties in an array
                let properties: NSArray = propertyJSON["properties"] as! NSArray
                
                //looping through all the objects in the array
                DispatchQueue.main.async(execute: {
                    for i in 0 ..< properties.count{
                        //Getting data from each listing and saving to vars
                        let propIdValue = properties[i] as? NSDictionary
                        let propertyID = propIdValue?["property_id"] as! Int
                        let landlordIdValue = properties[i] as? NSDictionary
                        let landlordID = landlordIdValue?["landlord_id"] as! String
                        let addressValue = properties[i] as? NSDictionary
                        let address = addressValue?["address"] as! String
                        let dateValue = properties[i] as? NSDictionary
                        let date = dateValue?["date_available"] as! String
                        let milesValue = properties[i] as? NSDictionary
                        let milesToGu = milesValue?["miles_to_gu"] as! String
                        let rentValue = properties[i] as? NSDictionary
                        let rentPerMonth = rentValue?["rent_per_month"] as! String
                        let depositValue = properties[i] as? NSDictionary
                        let deposit = depositValue?["deposit"] as! String
                        let roomsValue = properties[i] as? NSDictionary
                        let roomNumber = roomsValue?["number_of_rooms"] as! String
                        let bathroomValue = properties[i] as? NSDictionary
                        let bathroomNumber = bathroomValue?["number_of_bathrooms"] as! String
                        let leaseValue = properties[i] as? NSDictionary
                        let lease = leaseValue?["lease_length"] as! String
                        let propertyTypeValue = properties[i] as? NSDictionary
                        let propertyType = propertyTypeValue?["property_type"] as! String
                        let petValue = properties[i] as? NSDictionary
                        let pets = petValue?["pets"] as! String
                        let availabilityValue = properties[i] as? NSDictionary
                        let availability = availabilityValue?["availability"] as! String
                        let descriptionValue = properties[i] as? NSDictionary
                        let description = descriptionValue?["description"] as! String
                        let emailValue = properties[i] as? NSDictionary
                        let email = emailValue?["email"] as! String
                        let phoneNumberValue = properties[i] as? NSDictionary
                        let phoneNumber = phoneNumberValue?["phone_number"] as! String
                        let statusValue = properties[i] as? NSDictionary
                        let status = statusValue?["status"] as! String
                        
                        if (propertyID == self.propertyID) {
                            
                            let listing = Listing(propertyID: propertyID, landlordID: landlordID, address: address, dateAvailable : date, milesToGU: milesToGu, numberOfRooms: roomNumber, bathroomNumber: bathroomNumber, leaseLength: lease, monthRent: rentPerMonth, deposit : deposit, houseImage: nil, propertyType: propertyType, pets: pets, availability: availability, description: description, phoneNumber: phoneNumber, email : email, userID : "")
                            self.listing = listing
                        }
                        
                    }
          
                })
            }
            catch {
                print(error)
            }
        }
        getTask.resume()
    }
    
    
    @IBAction func approveEdits(_ sender: Any) {
        // Make pop up
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to approve these edits and make them visible?", preferredStyle: .alert)
        
        // If cancel, do nothing
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, upload the changes
        let alertActionYes = UIAlertAction(title: "Yes", style: .default){
            (_) in
            self.saveEdits()
            // Go back to previous page
            self.toHomePageButton1.sendActions(for: .touchUpInside)
            
        }
        alertVC.addAction(alertActionCancel)
        alertVC.addAction(alertActionYes)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    /* This function saves edits to the database and changes the status of a property */
    func saveEdits(){
        let saveRequestURL = NSURL(string: URL_APPROVE_EDIT)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        let currentProperty = String(propertyID)
        
        //concatenating keys and values from text field
        let postParameters="address="+address+"&rent_per_month="+rent+"&number_of_rooms="+rooms+"&property_id="+currentProperty+"&deposit="+deposit+"&number_of_bathrooms="+bathroomNumber+"&pets="+pets+"&availability="+availability+"&description="+propDescription+"&date_available="+dateAvailable+"&lease_length="+leaseLength+"&phone_number="+phoneNumber+"&email="+email+"&status=Approved"+"&miles_to_gu="+distance;
        
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
                //converting response to NSDictioanry
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
        
        
        let saveRequestURL2 = NSURL(string: self.statusChange)
        
        //creating NSMutableURLRequest
        let saveRequest2 = NSMutableURLRequest(url:saveRequestURL2! as URL)
        
        //setting method to POST
        saveRequest2.httpMethod = "POST"
        
        //getting values from text fields
        
        //let landlordID = self.firstName
        let postParameters2="status=Approved"+"&property_id="+String(self.propertyID);
        
        
        //adding parameters to request body
        saveRequest2.httpBody=postParameters2.data(using: String.Encoding.utf8)
        //task to send to post request
        let saveTask2=URLSession.shared.dataTask(with: saveRequest2 as URLRequest){
            data,response, error in
            if error != nil{
                print("error is \(error)")
                return;
            }
            do{
                //converting response to NSDictioanry
                
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
        saveTask2.resume()

    }

    @IBAction func discardEdits(_ sender: Any) {
        // Make pop up
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to disapprove these edits? If a listing has not been previously approved, doing this action will delete the listing.", preferredStyle: .alert)
        
        // If cancel, do nothing
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, upload the changes
        let alertActionYes = UIAlertAction(title: "Yes", style: .default){
            (_) in
            self.rejectEdit()
            // Go back to previous page
            self.toHomePageButton1.sendActions(for: .touchUpInside)
            
        }
        alertVC.addAction(alertActionCancel)
        alertVC.addAction(alertActionYes)
        self.present(alertVC, animated: true, completion: nil)

    }
    func rejectEdit()
    {
        let saveRequestURL = NSURL(string: URL_REJECT_EDIT)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        let currentProperty = String(propertyID)
        
        let origaddress = listing.address
        let origrent = listing.monthRent
        let origrooms = listing.numberOfRooms
        let origdeposit = listing.deposit
        let origbathroomNumber = listing.bathroomNumber
        let origpets = listing.pets
        let origpropDescription = listing.description
        let origavailability = listing.availability
        let origdateAvailable = listing.dateAvailable
        let origleaseLength = listing.leaseLength
        let origphoneNumber = listing.phoneNumber
        let origemail = listing.email
        let origdistance = listing.milesToGU
        
        //concatenating keys and values from text field
        let postParameters="address="+origaddress+"&rent_per_month="+origrent+"&number_of_rooms="+origrooms+"&property_id="+currentProperty+"&deposit="+origdeposit+"&number_of_bathrooms="+origbathroomNumber+"&pets="+origpets+"&availability="+origavailability+"&description="+origpropDescription+"&date_available="+origdateAvailable+"&lease_length="+origleaseLength+"&phone_number="+origphoneNumber+"&email="+origemail+"&status=Approved"+"&miles_to_gu="+origdistance;
        
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
                //converting response to NSDictioanry
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
        
        
        let saveRequestURL2 = NSURL(string: self.statusChange)
        
        //creating NSMutableURLRequest
        let saveRequest2 = NSMutableURLRequest(url:saveRequestURL2! as URL)
        
        //setting method to POST
        saveRequest2.httpMethod = "POST"
        
        //getting values from text fields
        
        //let landlordID = self.firstName
        let postParameters2="status=Approved"+"&property_id="+String(self.propertyID);
        
        
        //adding parameters to request body
        saveRequest2.httpBody=postParameters2.data(using: String.Encoding.utf8)
        //task to send to post request
        let saveTask2=URLSession.shared.dataTask(with: saveRequest2 as URLRequest){
            data,response, error in
            if error != nil{
                print("error is \(error)")
                return;
            }
            do{
                //converting response to NSDictioanry
                
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
        saveTask2.resume()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
