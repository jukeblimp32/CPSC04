//
//  EditListing.swift
//  Ocha
//
//  Created by Talkov, Leah C on 1/23/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class EditAdminListing: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
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
    var email : String = ""
    var phoneNumber : String = ""
    var imageURL : String = ""
    
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
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet var leaseSegment: UISegmentedControl!
    
    @IBOutlet weak var petPolicy: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        descriptionText.delegate = self
        determineAvailability()
        determineDate()
        determinePetPolicy()
        determineLease()
        addressTextField?.text = address
        addressTextField.delegate = self
        rentTextField?.text = rent
        rentTextField.delegate = self
        depositTextField?.text = deposit
        depositTextField.delegate = self
        bedroomTextField?.text = bedroomNum
        bathroomLabel?.text = bathroomNum
        descriptionText?.text = propDescription
        propertyImage.image = image
        phoneNumberTextField.text = phoneNumber
        phoneNumberTextField.delegate = self
        propertyImage.loadCachedImages(url: imageURL)
        descriptionText!.layer.borderWidth = 1
        descriptionText!.layer.borderColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1).cgColor
        
        let initialChars = propDescription.characters.count
        characterLabel.text = "Description: (" + String(900 - initialChars) + " characters remaining)"
        characterLabel.adjustsFontSizeToFitWidth = true
        propertyImage.contentMode = .scaleAspectFill
        propertyImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage)))
        propertyImage.isUserInteractionEnabled = true
        
        if (Double(bedroomNum) == nil) {
            stepper.value = 1
        }
        else {
            stepper.value = Double(bedroomNum)!
        }
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        if (Double(bathroomNum) == nil) {
            bathroomStepper.value = 1
        }
        else {
            bathroomStepper.value = Double(bathroomNum)!
        }
        bathroomStepper.wraps = true
        bathroomStepper.autorepeat = true
        bathroomStepper.minimumValue = 1
        bathroomStepper.maximumValue = 10
        self.addReturnButtonOnNumpad()
        
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (descriptionText.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        characterLabel.text = "Description: (" + String(900 - numberOfChars) + " characters remaining)"
        return numberOfChars <= 900;
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
        phoneNumberTextField.text = phoneNumber
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "backToAdminListing",
            //Sets the page to be loaded as ListingPage
            let destination = segue.destination as? AdminListingPage
            //Gets the selected cell index
        {
            //Setting the variables in the listing class to the cell info
            destination.address = address
            destination.rent = rent
            destination.rooms = bedroomNum
            destination.distance = distance
            destination.email = email
            destination.imageUrl = imageURL
            destination.propertyID = propertyID
            destination.leaseLength = leaseTerms
            destination.dateAvailable = dateAvailable
            destination.bathroomNumber = bathroomNum
            destination.deposit = deposit
            destination.pets = pets
            destination.availability = availability
            destination.propDescription = propDescription
            destination.phoneNumber = phoneNumber
        }
    }
    
    
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
        let editPhoneNumber = phoneNumberTextField.text
        
        print (phoneNumberTextField.text)
        
        //post parameter
        //concatenating keys and values from text field
        let postParameters="address="+editAddress!+"&rent_per_month="+editRent!+"&number_of_rooms="+editBedroom!+"&property_id="+currentProperty+"&deposit="+editDeposit!+"&number_of_bathrooms="+editBathroom!+"&pets="+editPet!+"&availability=+"+editStatus!+"&description="+editDescription!+"&date_available="+editDate+"&lease_length="+editLease!+"&phone_number="+editPhoneNumber!+"&email=" + email;
        
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
    
    // Called when 'return' key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed.
    {
        // Set so that hitting return key advances to next field
        if textField == self.addressTextField {
            self.phoneNumberTextField.becomeFirstResponder()
        }
            // If we are in any other field, dismiss keyboard
        else{
            textField.resignFirstResponder()
        }
        return true
        
    }
    
    
    /* Because numpad has no return key, we must add it ourselves*/
    func addReturnButtonOnNumpad()
    {
        // Add next button to rent keyboard.
        let nextToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        nextToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let next: UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(CreateListing.nextButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(next)
        
        nextToolbar.items = items
        nextToolbar.sizeToFit()
        
        self.rentTextField.inputAccessoryView = nextToolbar
        
        let returnToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        returnToolbar.barStyle = UIBarStyle.default
        
        let flexSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let returnB: UIBarButtonItem = UIBarButtonItem(title: "Return", style: UIBarButtonItemStyle.done, target: self, action: #selector(CreateListing.returnButtonAction))
        
        var items1 = [UIBarButtonItem]()
        items1.append(flexSpace1)
        items1.append(returnB)
        
        returnToolbar.items = items1
        returnToolbar.sizeToFit()
        
        self.depositTextField.inputAccessoryView = returnToolbar
        
    }
    
    func nextButtonAction()
    {
        self.depositTextField.becomeFirstResponder()
    }
    
    func returnButtonAction()
    {
        self.depositTextField.resignFirstResponder()
    }
    
}