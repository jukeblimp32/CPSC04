//
//  ApproveEditsPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class ApproveEditsPage: UITableViewController, MFMailComposeViewControllerDelegate {
    
    private var propertyStatus : String = ""
    
    var propStat : String = ""
    
    var imageUrl = ""
    var imageUrl2 = ""
    var imageUrl3 = ""
    var imageUrl4 = ""
    var imageUrl5 = ""
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
    var landlordID : String = ""
    var landlordName : String = ""
    var image : UIImage = UIImage(named: "default")!
    
    var listing = Listing(propertyID: 0, landlordID: "", address: "", dateAvailable: "", milesToGU: "", numberOfRooms: "", bathroomNumber: "", leaseLength: "", monthRent: "", deposit: "", houseImage: nil, propertyType: "", pets: "", availability: "", description: "", phoneNumber: "", email : "", userID : "")
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var propertyImage: UIImageView!
    @IBOutlet var dateAvailableLabel: UILabel!
    @IBOutlet var rentLabel: UILabel!
    @IBOutlet var bedroomLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    
    @IBOutlet var pictureScrollView: UIScrollView!
    @IBOutlet var typeLabel: UILabel!
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
    let getStatus = "http://147.222.165.203/MyWebService/api/getStatus.php"
    let deleteProperty = "http://147.222.165.203/MyWebService/api/RemoveProperty.php"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findOriginalListing()
        addressLabel.text = address
        typeLabel.text = "Property Type: " + propertyType
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
        addressLabel.adjustsFontSizeToFitWidth = true
        dateAvailableLabel.adjustsFontSizeToFitWidth = true
        typeLabel.adjustsFontSizeToFitWidth = true
        bedroomLabel.adjustsFontSizeToFitWidth = true
        rentLabel.adjustsFontSizeToFitWidth = true
        emailLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.adjustsFontSizeToFitWidth = true
        phoneLabel.adjustsFontSizeToFitWidth = true
        petsLabel.adjustsFontSizeToFitWidth = true
        leaseLabel.adjustsFontSizeToFitWidth = true
        getLandlordName()
        loadPictures()
    
      /*  print("LOOK")
        getPropertyStatus{
            propertyStat in
            print(propertyStat)
            self.propertyStatus = propertyStat
            print(self.propertyStatus)
            print(self.status())
            //print("in getpropstat function" + propertyStatus)
            //retun self.propertyStatus
        }*/
        //print("propertyStatus is: " + self.propStat)
        //print(status())
        //print (returningPropStat)
        //getPropertyStatus{propertyStatus in print(propertyStatus)}
    
    }
    
    
    func loadPictures() {
        let myImages = [self.imageUrl, self.imageUrl2, self.imageUrl3, self.imageUrl4, self.imageUrl5]
        
        let offset = view.frame.width * (20/100)
        let size = view.frame.width * (60/100)
        let imageWidth : CGFloat = size
        let imageHeight : CGFloat = size
        var xPosition : CGFloat = offset
        var scrollViewSize : CGFloat = 0
        
        for image in myImages {
            let myImageView : UIImageView = UIImageView()
            myImageView.contentMode = .scaleAspectFit
            myImageView.clipsToBounds = true
            myImageView.loadCachedImages(url: image)
            
            myImageView.frame.size.width = imageWidth
            myImageView.frame.size.height = imageHeight
            myImageView.frame.origin.x = xPosition
            myImageView.frame.origin.y = 0
            
            pictureScrollView.addSubview(myImageView)
            xPosition += imageWidth + offset
            scrollViewSize += imageWidth + offset
            
        }
        scrollViewSize += offset
        
        pictureScrollView.contentSize = CGSize(width: scrollViewSize, height: imageHeight)
    }

    func getPropertyStatus(callback:@escaping (String) -> ()){
        //var propertyStatus = ""
        //create NSURL
        let getRequestURL = NSURL(string: getStatus)
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
                let propStatus: NSArray = propertyJSON["propStatus"] as! NSArray
                //looping through all the objects in the array
                DispatchQueue.main.async(execute: {
                    for i in 0 ..< propStatus.count{
                        //Getting data from each listing and saving to vars
                        let propIdValue = propStatus[i] as? NSDictionary
                        let propertyID = propIdValue?["property_id"] as! Int
                        let statusValue = propStatus[i] as? NSDictionary
                        let status = statusValue?["status"] as! String
                        
                        if(propertyID == self.propertyID){
                            //propertyStatus = String(status)
                            callback(String(status))
                        }
                    }
                    
                })
            }
            catch {
                print(error)
            }
        }
        getTask.resume()
       // return propertyStatus
        
    }
    
    func status() -> String{
       // return getPropertyStatus()
        return self.propertyStatus
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
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to approve these edits and make them visible? After confirming, an email will open up. Send the email to the administrator.", preferredStyle: .alert)
        
        // If cancel, do nothing
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, upload the changes
        let alertActionYes = UIAlertAction(title: "Yes", style: .default){
            (_) in
            self.saveEdits()
            self.sendListingEmail()
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
    
    func sendListingEmail()
    {
        let listingEmail = configureEmail()
        // Can only send email if the device has mail set up
        if(MFMailComposeViewController.canSendMail())
        {
            self.present(listingEmail, animated: true, completion: nil)
        }
        else
        {
            print("Not enabled")
        }
    }
    
    func configureEmail() -> MFMailComposeViewController
    {
        let emailComposerVC = MFMailComposeViewController()
        emailComposerVC.mailComposeDelegate = self
        
        // Set info for sending
        let adminEmail = FIRAuth.auth()?.currentUser?.email
        /********************************************************************************************************
         * Still need to retrieve landlord name
         *******************************************************************************************************/
        let nameField = "Name: \(landlordName) \n\n"
        let emailField = "Email: \(email) \n\n"
        let phoneField = "Phone Number: \(phoneNumber) \n\n"
        let dateField = "Date Available: \(dateAvailable) \n\n"
        let houseField = "Housing Type: \(propertyType) \n\n"
        let bedBathField = "Number of Bedrooms & Bathrooms: \(rooms) Bedroom, \(bathroomNumber) Bathroom \n\n"
        let rentDepositField = "Rent & Deposit Amount: $\(rent) Rent, $\(deposit) Deposit \n\n"
        let leaseField = "Lease Terms: \(leaseLength) \n\n"
        let descriptionField = "About the Property (address, laundry, pets allowed, amenities, miles to GU, utilities included in rent, etc.): \(address) \n \(propDescription) Pets are a \(pets). \(distance) miles from GU \n"
        
        // Put all fields together
        let completeEmail = nameField + emailField + phoneField + dateField + houseField + bedBathField + rentDepositField + leaseField + descriptionField
        
        // Address email
        emailComposerVC.setToRecipients([adminEmail!])
        emailComposerVC.setSubject("Edit for listing at: \(address)")
        emailComposerVC.setMessageBody(completeEmail, isHTML: false)
        
        return emailComposerVC
    }
    
    func getLandlordName()
    {
        let dataRef = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
        let usersReference = dataRef.child("users").child(landlordID)
        
        // See if an instance of the user already exists
        usersReference.observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshot = snapshot.value as? NSDictionary
            // If there is no snapshot, there is no landlord. May need to look into this case more
            if(snapshot == nil)
            {
                self.landlordName = "Unknown"
            }
                // Otherwise, return the landlord name
            else
            {
                self.landlordName = (snapshot?["name"] as! String)
            }
        })
    }
    
    // May need alert to stop from cancelling
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }



    @IBAction func discardEdits(_ sender: Any) {
        // Make pop up
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to disapprove these edits? All edits will be lost. You can send an email to the landlord about suggesting edits", preferredStyle: .alert)
        
        // If cancel, do nothing
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, upload the changes
        let alertActionYes = UIAlertAction(title: "Yes", style: .default){
            (_) in
            
            //getPropertyStatus()
            let saveRequestURL = NSURL(string: self.URL_REJECT_EDIT)
            
            //creating NSMutableURLRequest
            let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
            
            //setting method to POST
            saveRequest.httpMethod = "POST"
            
            let currentProperty = String(self.propertyID)
            
            let origaddress = self.listing.address
            let origrent = self.listing.monthRent
            let origrooms = self.listing.numberOfRooms
            let origdeposit = self.listing.deposit
            let origbathroomNumber = self.listing.bathroomNumber
            let origpets = self.listing.pets
            let origpropDescription = self.listing.description
            let origavailability = self.listing.availability
            let origdateAvailable = self.listing.dateAvailable
            let origleaseLength = self.listing.leaseLength
            let origphoneNumber = self.listing.phoneNumber
            let origemail = self.listing.email
            let origdistance = self.listing.milesToGU
            
            
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
            
            self.getPropertyStatus{
                propertyStat in
                print(propertyStat)
                self.propertyStatus = propertyStat
                if (self.propertyStatus == "Approved"){
                    let saveRequestURL2 = NSURL(string: self.statusChange)
                    
                    //creating NSMutableURLRequest
                    let saveRequest2 = NSMutableURLRequest(url:saveRequestURL2! as URL)
                    
                    //setting method to POST
                    saveRequest2.httpMethod = "POST"
                    
                    let postParameters2="status=Editing"+"&property_id="+String(self.propertyID);
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
                    self.sendEditEmail()
                }
            }
            self.toHomePageButton1.sendActions(for: .touchUpInside)
            
        }
        alertVC.addAction(alertActionCancel)
        alertVC.addAction(alertActionYes)
        self.present(alertVC, animated: true, completion: nil)

    }
    

    func sendEditEmail()
    {
        // Can only send email if the device has mail set up
        if(MFMailComposeViewController.canSendMail())
        {
            // Address the email
            let editComposerVC = MFMailComposeViewController()
            editComposerVC.mailComposeDelegate = self
            editComposerVC.setToRecipients([email])
            editComposerVC.setSubject("Suggested Edits to Your Property at \(address)")
            self.present(editComposerVC, animated: true, completion: nil)
        }
        else
        {
            print("Not enabled")
        }
        
    }
    
    
    @IBAction func deleteListing(_ sender: Any) {
        // Create alert
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this listing?", preferredStyle: .alert)
        
        // Do nothing if we cancel
        let alertActionResend = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, delete the listing from the database
        let alertActionOkay = UIAlertAction(title: "Yes", style: .default){
            (_) in
            //created NSURL
            let saveRequestURL = NSURL(string: self.deleteProperty)
            
            //creating NSMutableURLRequest
            let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
            
            //setting method to POST
            saveRequest.httpMethod = "POST"
            
            //getting values from text fields
            
            //let landlordID = self.firstName
            print("OVERHERE")
            print(self.propertyID)
            let postParameters="property_id="+String(self.propertyID);
            
            
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
            // Go back to homepage
            self.toHomePageButton1.sendActions(for: .touchUpInside)
            
        }
        alertVC.addAction(alertActionResend)
        alertVC.addAction(alertActionOkay)
        self.present(alertVC, animated: true, completion: nil)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
