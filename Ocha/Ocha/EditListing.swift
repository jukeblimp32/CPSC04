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
    var bathroomNum : String = ""
    var distance : String = ""
    var dateAvailable : String = ""
    var pets : String = ""
    var deposit : String = ""
    var propDescription : String = ""
    var availability : String = ""
    var leaseTerms : String = " "
    var image : UIImage = UIImage(named: "default")!
    var propertyID : Int = 0
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var rentTextField: UITextField!
    @IBOutlet weak var depositTextField: UITextField!
    @IBOutlet weak var bedroomTextField: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var bathroomStepper: UIStepper!
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var propertyStatus: UISegmentedControl!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet var leaseSegment: UISegmentedControl!
    
    @IBOutlet weak var petPolicy: UISegmentedControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        determineAvailability()
        determineDate()
        determinePetPolicy()
        determineLease()
        addressTextField?.text = address
        rentTextField?.text = rent
        depositTextField?.text = deposit
        bedroomTextField?.text = bedroomNum
        bathroomLabel?.text = bathroomNum
        descriptionText?.text = propDescription
        propertyImage.image = image
        
        descriptionText!.layer.borderWidth = 1
        descriptionText!.layer.borderColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1).cgColor
        
        propertyImage.contentMode = .scaleAspectFill
        propertyImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage)))
        propertyImage.isUserInteractionEnabled = true
        
        stepper.value = Double(bedroomNum)!
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        bathroomStepper.value = Double(bathroomNum)!
        bathroomStepper.wraps = true
        bathroomStepper.autorepeat = true
        bathroomStepper.minimumValue = 1
        bathroomStepper.maximumValue = 10
    
    }
    
    func determineAvailability() {
        if (availability == "Open") {
            propertyStatus.selectedSegmentIndex = 0
        }
        else {
            propertyStatus.selectedSegmentIndex = 1
        }
    }
    
    func determineLease() {
        if (leaseTerms == "Monthly"){
            leaseSegment.selectedSegmentIndex = 0
        }
        else if (leaseTerms == "6-Month"){
            leaseSegment.selectedSegmentIndex = 1
        }
        else if (leaseTerms == "9-Month"){
            leaseSegment.selectedSegmentIndex = 2
        }
        else {
            leaseSegment.selectedSegmentIndex = 3
        }
    }
    
    //********In Progress
    func determineDate() {
        
    }
    
    func determinePetPolicy() {
        if (pets == "Yes") {
            petPolicy.selectedSegmentIndex = 0
        }
        else {
            petPolicy.selectedSegmentIndex = 1
        }
    }
    
    @IBAction func changeBathroomNumber(_ sender: UIStepper) {
        bathroomLabel.text = Int(sender.value).description
    }
    
    @IBAction func changeBedroomNumber(_ sender: UIStepper) {
        bedroomTextField.text = Int(sender.value).description
    }
    
    @IBAction func reverseChanges(_ sender: Any) {
        determineAvailability()
        determineDate()
        determinePetPolicy()
        determineLease()
        addressTextField?.text = address
        rentTextField.text = rent
        depositTextField.text = deposit
        bedroomTextField.text = bedroomNum
        bathroomLabel.text = bathroomNum
        stepper.value = Double(bedroomNum)!
        bathroomStepper.value = Double(bathroomNum)!
        descriptionText.text = propDescription
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
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        
        //getting values from fields
        let editAddress = addressTextField.text
        let editRent = rentTextField.text
        let editDeposit = depositTextField.text
        let editBedroom = bedroomTextField.text
        let editBathroom = bathroomLabel.text
        let editPet = petPolicy.titleForSegment(at:petPolicy.selectedSegmentIndex)
        let editStatus = propertyStatus.titleForSegment(at: propertyStatus.selectedSegmentIndex)
        let editDescription = descriptionText.text
        let editDate = dateFormatter.string(from: datePicker.date)
        let editLease = leaseSegment.titleForSegment(at: leaseSegment.selectedSegmentIndex)
 
        //post parameter
        //concatenating keys and values from text field
        let postParameters="address="+editAddress!+"&rent_per_month="+editRent!+"&number_of_rooms="+editBedroom!+"&property_id="+currentProperty+"&deposit="+editDeposit!+"&number_of_bathrooms="+editBathroom!+"&pets="+editPet!+"&availability=+"+editStatus!+"&description="+editDescription!+"&date_available="+editDate+"&lease_length="+editLease!;

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
