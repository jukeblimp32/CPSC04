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
import GoogleMaps
import CoreLocation

class CreateListing: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    
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
    var userType = ""
    var imageViewSelected = 1
    
    
    let URL_SAVE_PROPERTY = "http://147.222.165.203/MyWebService/api/landlordCreateProperty.php"
    let getProperties = "http://147.222.165.203/MyWebService/api/DisplayProperties.php"
    
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    let apiKey = GMSServices.provideAPIKey("AIzaSyAZiputpqkl-sCQk6gk5uTBQLJQVSe0684")
    
    
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet var uploadImageView2: UIImageView!
    @IBOutlet var uploadImageView3: UIImageView!
    @IBOutlet var uploadImageView4: UIImageView!
    @IBOutlet var uploadImageView5: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var myString: String = (dictionary["type"] as? String)!
                self.userType = myString
                print(myString)
            }
        }, withCancel: nil)
        
        
        
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
        
        uploadImageView2.image = UIImage(named: "default")
        uploadImageView2.contentMode = .scaleAspectFill
        uploadImageView2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage2)))
        uploadImageView2.isUserInteractionEnabled = true
        
        uploadImageView3.image = UIImage(named: "default")
        uploadImageView3.contentMode = .scaleAspectFill
        uploadImageView3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage3)))
        uploadImageView3.isUserInteractionEnabled = true
        
        uploadImageView4.image = UIImage(named: "default")
        uploadImageView4.contentMode = .scaleAspectFill
        uploadImageView4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage4)))
        uploadImageView4.isUserInteractionEnabled = true
        
        uploadImageView5.image = UIImage(named: "default")
        uploadImageView5.contentMode = .scaleAspectFill
        uploadImageView5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage5)))
        uploadImageView5.isUserInteractionEnabled = true
        
        
        characterLabel.adjustsFontSizeToFitWidth = true
        address.delegate = self
        phoneNumberTextField.delegate = self
        rent.delegate = self
        deposit.delegate = self
        propDescription.delegate = self
        self.addReturnButtonOnNumpad()
        
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (propDescription.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        characterLabel.text = "Description: (" + String(900 - numberOfChars) + " characters remaining)"
        characterLabel.adjustsFontSizeToFitWidth = true
        return numberOfChars <= 900;
    }
    
    
    @IBAction func changeBathroomNum(_ sender: UIStepper) {
        self.bathroomNumber.text = Int(sender.value).description
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
            if(results.count == 0) {
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
    
    
    @IBAction func submitListingInfo(_ sender: Any) {
        // Create alert
        let alertConfirm = UIAlertController(title: "Confirmation", message: "Are you sure you would like to post this listing? Doing so will make it visible to all student users.", preferredStyle: .alert)
        
        // Do nothing if we cancel
        let alertCancel = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, delete the listing from the database
        let alertYes = UIAlertAction(title: "Yes", style: .default){
            (_) in
            self.registerListing()
        }
        alertConfirm.addAction(alertCancel)
        alertConfirm.addAction(alertYes)
        self.present(alertConfirm, animated: true, completion: nil)

        
        
    }
    
    func registerListing(){
        //created NSURL
        let saveRequestURL = NSURL(string: URL_SAVE_PROPERTY)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields
        
        //let landlordID = self.firstName
        let uid = FIRAuth.auth()?.currentUser?.uid
        let email = FIRAuth.auth()?.currentUser?.email
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let landlordID = uid
        let propertyAddress = address.text
        let monthlyRent = rent.text
        let propertyDeposit = deposit.text
        let numberOfRooms = bedroomNumber.text
        let numberOfBathrooms = bathroomNumber.text
        
        let availableDate = dateFormatter.string(from: datePicker.date)
        //let milesToGu = milesToGU
        let lease = leaseLength.titleForSegment(at: leaseLength.selectedSegmentIndex)
        let propertyType = propType.titleForSegment(at:propType.selectedSegmentIndex)
        let petChoice = petPolicy.titleForSegment(at:petPolicy.selectedSegmentIndex)
        var description = " "
        let phoneNumber = phoneNumberTextField.text
        if (propDescription.text != nil){
            description = propDescription.text!
        }
        //let phoneNumber =
        
        
        let location = propertyAddress! + ", Spokane, WA, USA"
        let milesToGu = getLatLngForZip(address: location)
        
        // getLatLngForZip(address: location)
        //getmiles
        //miles = getmiles
        
        if propertyAddress == "" || monthlyRent == "" || propertyDeposit == "" || phoneNumber == ""
        {
            let alert = UIAlertController(title: "Empty Fields", message:"Make sure you have entered information for all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true){}
            
        }
        else {
            var postParameters = ""
            //post parameter
            //concatenating keys and values from text field
            
            if (userType == "Admin") {
                postParameters="landlord_id="+landlordID!+"&address="+propertyAddress!+"&rent_per_month="+monthlyRent!+"&deposit="+propertyDeposit!+"&number_of_rooms="+numberOfRooms!+"&number_of_bathrooms="+numberOfBathrooms!+"&date_available="+availableDate+"&miles_to_gu="+milesToGu+"&lease_length="+lease!+"&property_type="+propertyType!+"&pets="+petChoice!+"&description="+description+"&availability=Open"+"&phone_number="+phoneNumber!+"&email="+email!+"&status=Approved";
            }
            else {
                postParameters="landlord_id="+landlordID!+"&address="+propertyAddress!+"&rent_per_month="+monthlyRent!+"&deposit="+propertyDeposit!+"&number_of_rooms="+numberOfRooms!+"&number_of_bathrooms="+numberOfBathrooms!+"&date_available="+availableDate+"&miles_to_gu="+milesToGu+"&lease_length="+lease!+"&property_type="+propertyType!+"&pets="+petChoice!+"&description="+description+"&availability=Open"+"&phone_number="+phoneNumber!+"&email="+email!+"&status=Pending";
            }
            
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
            phoneNumberTextField.text = ""
            bedroomNumber.text = "1"
            bathroomNumber.text = "1"
            leaseLength.selectedSegmentIndex = 0
            propType.selectedSegmentIndex = 0
            propDescription.text = ""
            
        }

    }
    
    private func uploadImage(address : String)
    {
        let propertyMaxID = maxID + 1
        // Firebase images. First create a unique id number.
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("Listing Images").child("\(imageName).png")
        
        let fireData = FIRDatabase.database().reference(fromURL: "https://osha-6c505.firebaseio.com/")
        let listingsReference = fireData.child("listings").child(String(propertyMaxID))
        listingsReference.child("address").setValue(address)
        
        
        //Loading each image into firebase
        if let uploadData = UIImagePNGRepresentation(self.uploadImageView.image!)
        {
            print(uploadData)
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
        if let uploadData = UIImagePNGRepresentation(self.uploadImageView2.image!)
        {
            print(uploadData)
            storageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
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
        if let uploadData = UIImagePNGRepresentation(self.uploadImageView3.image!)
        {
                        print(uploadData)
            storageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
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
        if let uploadData = UIImagePNGRepresentation(self.uploadImageView4.image!)
        {
                        print(uploadData)
            storageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
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
        if let uploadData = UIImagePNGRepresentation(self.uploadImageView5.image!)
        {
                        print(uploadData)
            storageRef.put(uploadData, metadata: nil, completion: {(metadata, error) in
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
    
    func handleSelectListingImage(/*_ sender: UIImageView*/)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        imageViewSelected = 0
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
                uploadImageView.image = selectedImage
            }
            if imageViewSelected == 1 {
                uploadImageView2.image = selectedImage
            }
            if imageViewSelected == 2 {
                uploadImageView3.image = selectedImage
            }
            if imageViewSelected == 3 {
                uploadImageView4.image = selectedImage
            }
            if imageViewSelected == 4 {
                uploadImageView5.image = selectedImage
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
        if textField == self.address {
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
        
        self.rent.inputAccessoryView = nextToolbar
        
        let returnToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        returnToolbar.barStyle = UIBarStyle.default
        
        let flexSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let returnB: UIBarButtonItem = UIBarButtonItem(title: "Return", style: UIBarButtonItemStyle.done, target: self, action: #selector(CreateListing.returnButtonAction))
        
        var items1 = [UIBarButtonItem]()
        items1.append(flexSpace1)
        items1.append(returnB)
        
        returnToolbar.items = items1
        returnToolbar.sizeToFit()
        
        self.deposit.inputAccessoryView = returnToolbar
        
    }
    
    func nextButtonAction()
    {
        self.deposit.becomeFirstResponder()
    }
    
    func returnButtonAction()
    {
        self.deposit.resignFirstResponder()
    }

    
    
}
