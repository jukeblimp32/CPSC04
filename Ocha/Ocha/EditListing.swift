//
//  EditListing.swift
//  Ocha
//
//  Created by Talkov, Leah C on 1/23/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class EditListing: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    @IBOutlet weak var propertyImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField?.text = address
        rentTextField?.text = rent
        bedroomTextField?.text = bedroomNum
        propertyImage.image = image
        propertyImage.contentMode = .scaleAspectFill
        propertyImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage)))
        propertyImage.isUserInteractionEnabled = true
        stepper.value = Double(bedroomNum)!
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 30
    
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
        
        self.uploadImage()
        
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
    
    private func uploadImage()
    {
        // Firebase images. First create a unique id number.
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("Listing Images").child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(self.propertyImage.image!)
        {
            storageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                print(metadata)
                // Set values
                if let uploadImageUrl = metadata?.downloadURL()?.absoluteString{
                    let values = ["address": self.address, "image1": uploadImageUrl]
                    
                    // After uploading image to storage, add to property photos database
                    let fireData = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
                    /**********************************************************
                     * Need to swap out with property id
                     ***********************************************************/
                    let listingsReference = fireData.child("listings").child(String(self.propertyID))
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
            propertyImage.image = selectedImage
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
