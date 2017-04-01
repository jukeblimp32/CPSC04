//
//  EditListing.swift
//  Ocha
//
//  Created by Talkov, Leah C on 1/23/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import CoreLocation

class EditAdminListing: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    let URL_EDIT_PROPERTY = "http://147.222.165.203/MyWebService/api/adminEditProperty.php"
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    let apiKey = GMSServices.provideAPIKey("AIzaSyAZiputpqkl-sCQk6gk5uTBQLJQVSe0684")
    
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
    var imageURL2 : String = ""
    var imageURL3 : String = ""
    var imageURL4 : String = ""
    var imageURL5 : String = ""
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var rentTextField: UITextField!
    @IBOutlet weak var depositTextField: UITextField!
    @IBOutlet weak var bedroomTextField: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var bathroomStepper: UIStepper!
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet var propertyImage2: UIImageView!
    @IBOutlet var propertyImage3: UIImageView!
    @IBOutlet var propertyImage4: UIImageView!
    @IBOutlet var propertyImage5: UIImageView!
 
    @IBOutlet weak var propertyStatus: UISegmentedControl!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet var leaseSegment: UISegmentedControl!
    
    @IBOutlet weak var petPolicy: UISegmentedControl!
    
    var imageViewSelected = 0
    
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
        propertyImage2.loadCachedImages(url: imageURL2)
        propertyImage3.loadCachedImages(url: imageURL3)
        propertyImage4.loadCachedImages(url: imageURL4)
        propertyImage5.loadCachedImages(url: imageURL5)
        descriptionText!.layer.borderWidth = 1
        descriptionText!.layer.borderColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1).cgColor
        
        let initialChars = propDescription.characters.count
        characterLabel.text = "Description: (" + String(900 - initialChars) + " characters remaining)"
        characterLabel.adjustsFontSizeToFitWidth = true
        
        
        propertyImage.contentMode = .scaleAspectFill
        propertyImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage)))
        propertyImage.isUserInteractionEnabled = true
        
        propertyImage2.contentMode = .scaleAspectFill
        propertyImage2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage2)))
        propertyImage2.isUserInteractionEnabled = true
        
        propertyImage3.contentMode = .scaleAspectFill
        propertyImage3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage3)))
        propertyImage3.isUserInteractionEnabled = true
        
        propertyImage4.contentMode = .scaleAspectFill
        propertyImage4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage4)))
        propertyImage4.isUserInteractionEnabled = true
        
        propertyImage5.contentMode = .scaleAspectFill
        propertyImage5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage5)))
        propertyImage5.isUserInteractionEnabled = true
        
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
            destination.imageUrl2 = imageURL2
            destination.imageUrl3 = imageURL3
            destination.imageUrl4 = imageURL4
            destination.imageUrl5 = imageURL5
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
    
    
    func getLatLngForZip(address: String) -> String {
        // var coordinateAddress!
        let key = "AIzaSyCoeK0AFvWvqHTIHOrlzvOKK2YeaoGa7Gk"
        var distanceInMiles = ""
        let url : NSString = "\(baseUrl)address=\(address)&key=\(key)" as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL  : NSURL = NSURL(string: urlStr as String)!
        
        let data = NSData(contentsOf: searchURL as URL)
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        if let results = json["results"] as? [[String: AnyObject]] {
            if (results.count == 0) {
                return "N/A"
            }
            let result = results[0]
            if let geometry = result["geometry"] as? [String:AnyObject] {
                if let location = geometry["location"] as? [String:Double] {
                    let lat = location["lat"]
                    let lon = location["lng"]
                    let latitude = Double(lat!)
                    let longitude = Double(lon!)
                    let coordinateAddress = CLLocation(latitude: latitude, longitude: longitude)
                    let coordinateHome = CLLocation(latitude: 47.667160, longitude:-117.402342)
                    let distanceInMeters = coordinateHome.distance(from: coordinateAddress)
                    let distance = distanceInMeters/1609.34
                    let decimalDistance = Double(round(100*distance)/100)
                    distanceInMiles = String(decimalDistance)
                    
                    print("MILES")
                    print(distanceInMiles)
                    // print("OVERHERE")
                    print("\n\(latitude), \(longitude)")
                    //return distanceInMiles
                }
            }
        }
        return distanceInMiles
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
        
        
        
        let stringAddress = String(editAddress!)
        
        let location = stringAddress! + ", Spokane, WA, USA"
        let editMilesToGu = getLatLngForZip(address: location)

        
        //post parameter
        //concatenating keys and values from text field
        let postParameters="address="+editAddress!+"&rent_per_month="+editRent!+"&number_of_rooms="+editBedroom!+"&property_id="+currentProperty+"&deposit="+editDeposit!+"&number_of_bathrooms="+editBathroom!+"&pets="+editPet!+"&availability="+editStatus!+"&description="+editDescription!+"&date_available="+editDate+"&lease_length="+editLease!+"&phone_number="+editPhoneNumber!+"&email=" + email+"&status=Approved"+"&miles_to_gu="+editMilesToGu;
        
        //adding parameters to request body
        saveRequest.httpBody=postParameters.data(using: String.Encoding.utf8)
        
        self.uploadImage(address: editAddress!)
        
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
        
        let alert = UIAlertController(title: "Property Edited!", message: "The property has been edited.", preferredStyle: .alert)
        let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(alertActionOkay)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func uploadImage(address : String){
        
        // Firebase images. First create a unique id number.
        let imageName = NSUUID().uuidString
        let imageName2 = NSUUID().uuidString
        let imageName3 = NSUUID().uuidString
        let imageName4 = NSUUID().uuidString
        let imageName5 = NSUUID().uuidString
        
        let storageRef = FIRStorage.storage().reference().child("Listing Images").child("\(imageName).png")
        let storageRef2 = FIRStorage.storage().reference().child("Listing Images").child("\(imageName2).png")
        let storageRef3 = FIRStorage.storage().reference().child("Listing Images").child("\(imageName3).png")
        let storageRef4 = FIRStorage.storage().reference().child("Listing Images").child("\(imageName4).png")
        let storageRef5 = FIRStorage.storage().reference().child("Listing Images").child("\(imageName5).png")
        
        
        let fireData = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
        let listingsReference = fireData.child("listings").child(String(self.propertyID))
        listingsReference.child("address").setValue(address)
        
        //Loading each image into firebase
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
                    listingsReference.child("image1").setValue(uploadImageUrl)
                }
                
                
            })
            
        }
        if let uploadData = UIImagePNGRepresentation(self.propertyImage2.image!)
        {
            storageRef2.put(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                print(metadata)
                // Set values
                if let uploadImageUrl = metadata?.downloadURL()?.absoluteString{
                    listingsReference.child("image2").setValue(uploadImageUrl)
                }
                
                
            })
            
        }
        if let uploadData = UIImagePNGRepresentation(self.propertyImage3.image!)
        {
            storageRef3.put(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                print(metadata)
                // Set values
                if let uploadImageUrl = metadata?.downloadURL()?.absoluteString{
                    listingsReference.child("image3").setValue(uploadImageUrl)
                    
                }
                
            })
            
        }
        if let uploadData = UIImagePNGRepresentation(self.propertyImage4.image!)
        {
            storageRef4.put(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                print(metadata)
                // Set values
                if let uploadImageUrl = metadata?.downloadURL()?.absoluteString{
                    listingsReference.child("image4").setValue(uploadImageUrl)
                    
                }
                
            })
            
        }
        if let uploadData = UIImagePNGRepresentation(self.propertyImage5.image!)
        {
            storageRef5.put(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error)
                    return
                }
                print(metadata)
                // Set values
                if let uploadImageUrl = metadata?.downloadURL()?.absoluteString{
                    listingsReference.child("image5").setValue(uploadImageUrl)
                    
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
    
    func handleSelectListingImage2(/*_ sender: UIImageView*/)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        imageViewSelected = 1
    }
    
    func handleSelectListingImage3(/*_ sender: UIImageView*/)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        imageViewSelected = 2
    }
    
    func handleSelectListingImage4(/*_ sender: UIImageView*/)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        imageViewSelected = 3
    }
    
    func handleSelectListingImage5(/*_ sender: UIImageView*/)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        imageViewSelected = 4
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
            if imageViewSelected == 0 {
                propertyImage.image = selectedImage
            }
            if imageViewSelected == 1 {
                propertyImage2.image = selectedImage
            }
            if imageViewSelected == 2 {
                propertyImage3.image = selectedImage
            }
            if imageViewSelected == 3 {
                propertyImage4.image = selectedImage
            }
            if imageViewSelected == 4 {
                propertyImage5.image = selectedImage
            }
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
