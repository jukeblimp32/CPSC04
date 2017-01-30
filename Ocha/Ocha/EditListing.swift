//
//  EditListing.swift
//  Ocha
//
//  Created by Talkov, Leah C on 1/23/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class EditListing: UITableViewController {
    
    let URL_EDIT_PROPERTY = "http://147.222.165.203/MyWebService/api/editProperties.php"
    
    var address : String = ""
    
    var rent : String = ""
    
    var bedroomNum : String = ""
    
    var distance : String = ""
    
    var image : UIImage = UIImage(named: "default")!
    
    var propertyID : Int = 0
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var rentTextField: UITextField!
    
    @IBOutlet weak var bedroomTextField: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField?.text = address
        rentTextField?.text = rent
        bedroomTextField?.text = bedroomNum
        stepper.value = Double(bedroomNum)!
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 10
    
    }
    
    @IBAction func changeBedroomNumber(_ sender: UIStepper) {
        bedroomTextField.text = Int(sender.value).description
    }
    
    @IBAction func reverseChanges(_ sender: Any) {
        addressTextField?.text = address
        rentTextField.text = rent
        bedroomTextField.text = bedroomNum
        stepper.value = Double(bedroomNum)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "backToListing",
            //Sets the page to be loaded as ListingPage
            let destination = segue.destination as? ListingPage
            //Gets the selected cell index
        {
            //Setting the variables in the listing class to the cell info
            destination.address.text = address
            destination.rent.text = rent
            destination.rooms.text = bedroomNum
            destination.distance.text = distance
            destination.image.image = image
            destination.propertyID = propertyID
        }
    }
    

    
    //OVER HERE ELMA :) :) :)
    @IBAction func saveEdits(_ sender: Any) {
        //created NSURL
        let saveRequestURL = NSURL(string: URL_EDIT_PROPERTY)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        let currentProperty = String(propertyID)
        
        //getting values from fields
        let editAddress = addressTextField.text
        let editRent = rentTextField.text
        let editBedroom = bedroomTextField.text

 
            
        //post parameter
        //concatenating keys and values from text field
        let postParameters="address="+editAddress!+"&rent_per_month="+editRent!+"&number_of_rooms="+editBedroom!+"&property_id="+currentProperty;
        
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
        
        let alert = UIAlertController(title: "Property Edited!", message: "Property will be sent for review before being published", preferredStyle: .alert)
        let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(alertActionOkay)
        self.present(alert, animated: true, completion: nil)

    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }  
}
