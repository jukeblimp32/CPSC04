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
    
    
    let URL_APPROVE_EDIT = "http://147.222.165.203/MyWebService/api/approveEdits.php"
    let URL_REJECT_EDIT = "http://147.222.165.203/MyWebService/api/rejectEdits.php"
    let statusChange = "http://147.222.165.203/MyWebService/api/statusChange.php"
    
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
    
    @IBAction func approveEdits(_ sender: Any) {
        let saveRequestURL = NSURL(string: URL_APPROVE_EDIT)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        let currentProperty = String(propertyID)

        //concatenating keys and values from text field
        let postParameters="address="+address+"&rent_per_month="+rent+"&number_of_rooms="+rooms+"&property_id="+currentProperty+"&deposit="+deposit+"&number_of_bathrooms="+bathroomNumber+"&pets="+pets+"&availability=+"+availability+"&description="+propDescription+"&date_available="+dateAvailable+"&lease_length="+leaseLength+"&phone_number="+phoneNumber+"&email="+email+"&status=Approved"+"&miles_to_gu="+distance;
        
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
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
