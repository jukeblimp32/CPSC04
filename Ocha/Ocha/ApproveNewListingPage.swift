//
//  ApproveNewListingPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class ApproveNewListingPage: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let removeProperty = "http://147.222.165.203/MyWebService/api/RemoveProperty.php"
    let statusChange = "http://147.222.165.203/MyWebService/api/statusChange.php"
    
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
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var propertyImage: UIImageView!
    @IBOutlet var dateAvailableLabel: UILabel!
    @IBOutlet var rentLabel: UILabel!
    @IBOutlet var bedroomLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    
    @IBOutlet var pictureScrollView: UIScrollView!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet weak var toHomePageButton: UIButton!
    
    @IBOutlet var petsLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var leaseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        bedroomLabel.adjustsFontSizeToFitWidth = true
        rentLabel.adjustsFontSizeToFitWidth = true
        emailLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.adjustsFontSizeToFitWidth = true
        phoneLabel.adjustsFontSizeToFitWidth = true
        petsLabel.adjustsFontSizeToFitWidth = true
        leaseLabel.adjustsFontSizeToFitWidth = true
        getLandlordName()
        loadPictures()
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
    
    //THIS DELETES FROM BOTH EDIT AND ORIG PROP TABLE
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
            let saveRequestURL = NSURL(string: self.removeProperty)
            
            //creating NSMutableURLRequest
            let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
            
            //setting method to POST
            saveRequest.httpMethod = "POST"
            
            //getting values from text fields
            
            //let landlordID = self.firstName
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
            self.toHomePageButton.sendActions(for: .touchUpInside)

        }
        alertVC.addAction(alertActionResend)
        alertVC.addAction(alertActionOkay)
        self.present(alertVC, animated: true, completion: nil)
    }

    
    @IBAction func suggestEdits(_ sender: Any) {
        // Make pop up
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to send an email to the landlord about suggested edits?", preferredStyle: .alert)
        
        // If cancel, do nothing
        let alertActionResend = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, open up the email app after switching to edit status
        let alertActionOkay = UIAlertAction(title: "Yes", style: .default){
            (_) in
            
            //created NSURL
            let saveRequestURL = NSURL(string: self.statusChange)
            
            //creating NSMutableURLRequest
            let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
            
            //setting method to POST
            saveRequest.httpMethod = "POST"
            
            //getting values from text fields
            
            //let landlordID = self.firstName
            let postParameters="status=Editing"+"&property_id="+String(self.propertyID);
            
            
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

            self.sendEditEmail()
            // Go back to previous page
            self.toHomePageButton.sendActions(for: .touchUpInside)
            
        }
        alertVC.addAction(alertActionResend)
        alertVC.addAction(alertActionOkay)
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
    
    
    
    @IBAction func approveListing(_ sender: Any) {
        // Make pop up
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to approve this listing? After confirming, an email will open up. Send the email to the administrator.", preferredStyle: .alert)
        
        // If cancel, do nothing
        let alertActionResend = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If we approve, update in database
        let alertActionOkay = UIAlertAction(title: "Yes", style: .default){
            (_) in
            //created NSURL
            let saveRequestURL = NSURL(string: self.statusChange)
            
            //creating NSMutableURLRequest
            let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
            
            //setting method to POST
            saveRequest.httpMethod = "POST"
            
            //getting values from text fields
            
            //let landlordID = self.firstName
            let postParameters="status=Approved"+"&property_id="+String(self.propertyID);
            
            
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
            // Send email
            self.sendListingEmail()
            // Go back to previous page
            self.toHomePageButton.sendActions(for: .touchUpInside)

        }
        alertVC.addAction(alertActionResend)
        alertVC.addAction(alertActionOkay)
        self.present(alertVC, animated: true, completion: nil)
        
        
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
        emailComposerVC.setSubject("New listing for: \(address)")
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
