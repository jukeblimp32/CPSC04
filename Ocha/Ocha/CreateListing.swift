//
//  CreateListing.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/28/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class CreateListing: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var bedroomNumber: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bathroomNumber: UILabel!
    @IBOutlet weak var bedroomStepper: UIStepper!
    @IBOutlet weak var bathroomStepper: UIStepper!
    @IBOutlet weak var rent: UITextField!
    @IBOutlet weak var leaseLength: UISegmentedControl!
    @IBOutlet weak var petPolicy: UISegmentedControl!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var propDescription: UITextView!
    @IBOutlet weak var deposit: UITextField!
    @IBOutlet weak var propType: UISegmentedControl!
    @IBOutlet var phoneNumberTextField: UITextField!
    var propertyIDs = [Int]()
    var maxID = 0
    var milesToGU : String = "0.5"
    
    /*lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "default")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
       // imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }() */

    
    let URL_SAVE_PROPERTY = "http://147.222.165.203/MyWebService/api/CreateProperty.php"
    let getProperties = "http://147.222.165.203/MyWebService/api/DisplayProperties.php"
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        propDescription!.layer.borderWidth = 1
        propDescription!.layer.borderColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1).cgColor
        
        bathroomStepper.wraps = true
        bathroomStepper.autorepeat = true
        bathroomStepper.minimumValue = 1
        bathroomStepper.maximumValue = 10
        
        bedroomStepper.wraps = true
        bedroomStepper.autorepeat = true
        bedroomStepper.minimumValue = 1
        bedroomStepper.maximumValue = 10
        
        uploadImageView.image = UIImage(named: "default")
        uploadImageView.contentMode = .scaleAspectFill
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage)))
        uploadImageView.isUserInteractionEnabled = true
        
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
                for i in 0 ..< properties.count{
                    //Getting data from each listing and saving to vars
                    let propIdValue = properties[i] as? NSDictionary
                    let propertyID = propIdValue?["property_id"] as! Int
                    self.propertyIDs.append(propertyID)
                }
                self.maxID = Int(self.propertyIDs.max()!)
            }
            catch {
                print(error)
            }
        }
        getTask.resume()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func changedBedroomNum(_ sender: UIStepper) {
        self.bedroomNumber.text = Int(sender.value).description
    }
    
    
    @IBAction func changeBathroomNum(_ sender: UIStepper) {
        self.bathroomNumber.text = Int(sender.value).description
    }
    
    
    @IBAction func submitListingInfo(_ sender: Any) {
        //created NSURL
        let saveRequestURL = NSURL(string: URL_SAVE_PROPERTY)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields

        //let landlordID = self.firstName
        let uid = FIRAuth.auth()?.currentUser?.uid

        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let landlordID = uid
        let propertyAddress = address.text
        let monthlyRent = rent.text
        let propertyDeposit = deposit.text
        let numberOfRooms = bedroomNumber.text
        let numberOfBathrooms = bathroomNumber.text

        let availableDate = dateFormatter.string(from: datePicker.date)
        let milesToGu = milesToGU
        let lease = leaseLength.titleForSegment(at: leaseLength.selectedSegmentIndex)
        let propertyType = propType.titleForSegment(at:propType.selectedSegmentIndex)
        let petChoice = petPolicy.titleForSegment(at:petPolicy.selectedSegmentIndex)
        var description = " "
        let phoneNumber = phoneNumberTextField.text
        if (propDescription.text != nil){
            description = propDescription.text!
        }
        //let phoneNumber =

        if propertyAddress == "" || monthlyRent == "" || propertyDeposit == ""
        {
            let alert = UIAlertController(title: "Empty Fields", message:"Make sure you have entered information for all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true){}
            
        }
        else {
        
            //post parameter
            //concatenating keys and values from text field

            let postParameters="landlord_id="+landlordID!+"&address="+propertyAddress!+"&rent_per_month="+monthlyRent!+"&deposit="+propertyDeposit!+"&number_of_rooms="+numberOfRooms!+"&number_of_bathrooms="+numberOfBathrooms!+"&date_available="+availableDate+"&miles_to_gu="+milesToGu+"&lease_length="+lease!+"&property_type="+propertyType!+"&pets="+petChoice!+"&description="+description+"&availability=Open"+"&phone_number="+phoneNumber!;
            
            // Upload Image
            self.uploadImage(address: propertyAddress!)
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
                    
                    let alert = UIAlertController(title: "Property Added!", message:"Property will be sent for review before being published", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default))
                    self.present(alert, animated: true){}
                    
                    //Here is the problem child
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
            sleep(2)
            tabBarController?.selectedIndex = 0
            address.text = ""
            rent.text = ""
            deposit.text = ""
            bedroomNumber.text = "1"
            bathroomNumber.text = "1"
            leaseLength.selectedSegmentIndex = 0
            propType.selectedSegmentIndex = 0

        }
    }
    
    private func uploadImage(address : String)
    {
        let propertyMaxID = maxID + 1
        // Firebase images. First create a unique id number.
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("Listing Images").child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(self.uploadImageView.image!)
        {
            storageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                print(metadata)
                // Set values
                if let uploadImageUrl = metadata?.downloadURL()?.absoluteString{
                    let values = ["address": address, "image1": uploadImageUrl]
                    
                    // After uploading image to storage, add to property photos database
                    let fireData = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
                    /**********************************************************
                     * Need to swap out with property id
                     ***********************************************************/
                    let listingsReference = fireData.child("listings").child(String(propertyMaxID))
                    listingsReference.updateChildValues(values, withCompletionBlock: {
                        (err, ref) in
                        if err != nil {
                            print(err)
                            return
                        }
                        
                    })
                    
                }
                
                
            })
            
        }

    }
    
    func handleSelectListingImage()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            uploadImageView.image = selectedImage
        }
        dismiss(animated:true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled picker")
        dismiss(animated: true, completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
