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
    @IBOutlet weak var deposit: UITextField!
    
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
    
    let uploadImageView = UIImageView()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.frame = self.view.bounds
        frame.size.height = frame.size.height - 40;
        
        bathroomStepper.wraps = true
        bathroomStepper.autorepeat = true
        bathroomStepper.minimumValue = 1
        bathroomStepper.maximumValue = 10
        
        bedroomStepper.wraps = true
        bedroomStepper.autorepeat = true
        bedroomStepper.minimumValue = 1
        bedroomStepper.maximumValue = 10
        
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

        
        if propertyAddress == "" || monthlyRent == "" || propertyDeposit == "" || numberOfRooms == "" || numberOfBathrooms == "" || availableDate == "" || milesToGu == "" || lease == ""
        {
            let alert = UIAlertController(title: "Empty Fields", message:"Make sure you have entered information for all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true){}
            
        }
        else {
        
            //post parameter
            //concatenating keys and values from text field
            let postParameters="landlord_id="+landlordID!+"&address="+propertyAddress!+"&rent_per_month="+monthlyRent!+"&deposit="+propertyDeposit!+"&number_of_rooms="+numberOfRooms!+"&number_of_bathrooms="+numberOfBathrooms!+"&date_available="+availableDate+"&miles_to_gu="+milesToGu+"&lease_length="+lease!;
            
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
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                    if let parseJSON = myJSON{
                        var msg:String!
                        msg = parseJSON["message"]as! String?
                        print(msg)
                    }
                    let alert = UIAlertController(title: "Property Added!", message:"Property will be sent for review before being published", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default))
                    self.present(alert, animated: true){}
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
            bedroomNumber.text = ""
            bathroomNumber.text = ""
            leaseLength.selectedSegmentIndex = 0

        }
    }
    
    private func uploadImage(address : String)
    {
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
                    let listingsReference = fireData.child("listings").child("89")
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
