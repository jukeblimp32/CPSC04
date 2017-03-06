//
//  ApproveNewListingPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class ApproveNewListingPage: UITableViewController {
    
    let removeProperty = "http://147.222.165.203/MyWebService/api/RemoveProperty.php"
    let statusChange = "http://147.222.165.203/MyWebService/api/statusChange.php"
    
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
    
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var propertyImage: UIImageView!
    @IBOutlet var dateAvailableLabel: UILabel!
    @IBOutlet var rentLabel: UILabel!
    @IBOutlet var bedroomLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    
    @IBOutlet weak var toHomePageButton: UIButton!
    
    @IBOutlet var petsLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var leaseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //THIS CHANGES STATUS TO "APPROVED" IN EDIT AND ORIG PROP TABLE
    @IBAction func approveListing(_ sender: Any) {
        // Make pop up
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to approve this listing?", preferredStyle: .alert)
        
        // If cancel, do nothing
        let alertActionResend = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If we approve, update in database
        let alertActionOkay = UIAlertAction(title: "Yes", style: .default){
            (_) in
            // Go back to login
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
            // Go back to previous page
            self.toHomePageButton.sendActions(for: .touchUpInside)

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
