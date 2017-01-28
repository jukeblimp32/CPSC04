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

class CreateListing: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    let address = UITextField()
    let rentPerMonth = UITextField()
    let deposit = UITextField()
    let tenantNumber = UITextField()
    let bedroomNumber = UITextField()
    let bathroomNumber = UITextField()
    let milesToGU = UITextField()
    let dateAvailable = UITextField()
    let leaseLength = UITextField()
    let uploadImageView = UIImageView()
    
    var propertyIDs = [Int]()
    var maxID = 0
    
    //var firstName = " "
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 400)
        // Do any additional setup after loading the view, typically from a nib.
        
        //View title
        //THIS WILL CHANGE TO HAVE A LABEL THAT CAN HAVE EDIT CURRENT LISTING OR CREATE
        let viewTitle = UILabel()
        viewTitle.text = "Create A New Listing"
        viewTitle.font = UIFont(name: viewTitle.font.fontName, size: 20)
        viewTitle.textColor = UIColor.white
        viewTitle.textAlignment = .center
        viewTitle.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (13/100), width: view.frame.width * (80/100), height: 40)
        scrollView.addSubview(viewTitle)
        
        
        //address label
        let addressLabel = UILabel()
        addressLabel.text = "Address:"
        addressLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        addressLabel.textColor = UIColor.white
        addressLabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (20/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(addressLabel)
        
        //rent label
        let rentLabel = UILabel()
        rentLabel.text = "Monthly Rent:"
        rentLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        rentLabel.textColor = UIColor.white
        rentLabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (27/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(rentLabel)
        
        //deposit label
        let depositLabel = UILabel()
        depositLabel.text = "Deposit:"
        depositLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        depositLabel.textColor = UIColor.white
        depositLabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (34/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(depositLabel)
        
        //tenant label
        let tenantLabel = UILabel()
        tenantLabel.text = "Number of Tenants:"
        tenantLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        tenantLabel.textColor = UIColor.white
        tenantLabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (41/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(tenantLabel)
        
        //bedroom Label
        let bedroomLabel = UILabel()
        bedroomLabel.text = "Number of Bedrooms:"
        bedroomLabel.adjustsFontSizeToFitWidth = true
        bedroomLabel.minimumScaleFactor = 0.5
        bedroomLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        bedroomLabel.textColor = UIColor.white
        bedroomLabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (48/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(bedroomLabel)
        
        //bathroom Label
        let bathroomLabel = UILabel()
        bathroomLabel.text = "Number of Bathrooms:"
        bathroomLabel.adjustsFontSizeToFitWidth = true
        bathroomLabel.minimumScaleFactor = 0.5
        bathroomLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        bathroomLabel.textColor = UIColor.white
        bathroomLabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (55/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(bathroomLabel)
        
        //miles to GU
        let milesToGULabel = UILabel()
        milesToGULabel.text = "Miles to GU:"
        milesToGULabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        milesToGULabel.textColor = UIColor.white
        milesToGULabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (62/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(milesToGULabel)
        
        //date available label
        let dateLabel = UILabel()
        dateLabel.text = "Date Available:"
        dateLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        dateLabel.textColor = UIColor.white
        dateLabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (69/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(dateLabel)
        
        //lease length label
        let leaseLengthLabel = UILabel()
        leaseLengthLabel.text = "Lease Length:"
        leaseLengthLabel.font = UIFont(name: viewTitle.font.fontName, size: 15)
        leaseLengthLabel.textColor = UIColor.white
        leaseLengthLabel.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (76/100), width: view.frame.width / 2, height: 15)
        scrollView.addSubview(leaseLengthLabel)
        

        //address textfield
        address.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (20/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(address)
        address.borderStyle = UITextBorderStyle.roundedRect
        address.backgroundColor = UIColor.white
        self.address.delegate = self
        
        //rent textfield
        rentPerMonth.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (27/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(rentPerMonth)
        rentPerMonth.borderStyle = UITextBorderStyle.roundedRect
        rentPerMonth.backgroundColor = UIColor.white
        self.rentPerMonth.delegate = self
        
        //deposit textfield
        deposit.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (34/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(deposit)
        deposit.borderStyle = UITextBorderStyle.roundedRect
        deposit.backgroundColor = UIColor.white
        self.deposit.delegate = self
        
        //tenant textfield
        tenantNumber.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (41/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(tenantNumber)
        tenantNumber.borderStyle = UITextBorderStyle.roundedRect
        tenantNumber.backgroundColor = UIColor.white
        //tenantNumber.isSecureTextEntry = true
        self.tenantNumber.delegate = self
        
        //bedroom textfield
        bedroomNumber.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (48/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(bedroomNumber)
        bedroomNumber.borderStyle = UITextBorderStyle.roundedRect
        bedroomNumber.backgroundColor = UIColor.white
        //bedroomNumber.isSecureTextEntry = true
        self.bedroomNumber.delegate = self
        
        //bathroom textfield
        bathroomNumber.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (55/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(bathroomNumber)
        bathroomNumber.borderStyle = UITextBorderStyle.roundedRect
        bathroomNumber.backgroundColor = UIColor.white
        self.bathroomNumber.delegate = self
        
        
        milesToGU.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (62/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(milesToGU)
        milesToGU.borderStyle = UITextBorderStyle.roundedRect
        milesToGU.backgroundColor = UIColor.white
        self.milesToGU.delegate = self
        
        dateAvailable.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (69/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(dateAvailable)
        dateAvailable.borderStyle = UITextBorderStyle.roundedRect
        dateAvailable.backgroundColor = UIColor.white
        dateAvailable.placeholder = "MM-DD-YYYY"
        self.dateAvailable.delegate = self
        
        leaseLength.frame = CGRect(x: (view.frame.width) / 1.8, y: (view.frame.height) * (76/100), width: view.frame.width * 0.4, height: 25)
        scrollView.addSubview(leaseLength)
        leaseLength.borderStyle = UITextBorderStyle.roundedRect
        leaseLength.backgroundColor = UIColor.white
        // Make the final field have a done button rather than return
        leaseLength.returnKeyType = UIReturnKeyType.done
        self.leaseLength.delegate = self
        
        uploadImageView.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (90/100), width: view.frame.width * 0.4, height: 25)
        uploadImageView.image = UIImage(named: "default")
        uploadImageView.contentMode = .scaleAspectFill
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectListingImage)))
        uploadImageView.isUserInteractionEnabled = true
        scrollView.addSubview(uploadImageView)
        
        
        //Submit button
        let submitButton = UIButton()
        submitButton.frame = CGRect(x: (view.frame.width) * (2/3), y: (view.frame.height) * (90/100), width: view.frame.width * (1/4), height: 30)
        submitButton.setTitle("Submit", for: UIControlState.normal)
        submitButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        submitButton.titleLabel?.textColor = UIColor.white
        submitButton.addTarget(self, action: #selector(CreateListing.submitListingInfo(_:)), for: UIControlEvents.touchUpInside)
        submitButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        submitButton.layer.cornerRadius = 4
        scrollView.addSubview(submitButton)
        self.scrollView.addSubview(submitButton)

        
        //logout button
        let toHomePageButton = UIButton()
        toHomePageButton.frame = CGRect(x: (view.frame.width) * (5/100), y: (view.frame.height) * (5/100), width: view.frame.width * (25/100) , height: 20)
        toHomePageButton.setTitle("Logout", for: UIControlState.normal)
        toHomePageButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        toHomePageButton.titleLabel?.textColor = UIColor.white
        toHomePageButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        toHomePageButton.layer.cornerRadius = 4
        toHomePageButton.addTarget(self, action: #selector(CreateListing.logout(_:)), for: UIControlEvents.touchUpInside)
        scrollView.addSubview(toHomePageButton)
        self.scrollView.addSubview(toHomePageButton)
        
        view.addSubview(scrollView)
        

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
        
        
    }
    
    
    //OVER HERE ELMA :)
    func submitListingInfo(_ sender : UIButton) {
        /*
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var myString: String = (dictionary["name"] as? String)!
                var myStringArr = myString.components(separatedBy: " ")
                    self.firstName = myStringArr[0]
            }
            
            }, withCancel: nil)
        */
        //created NSURL
        let saveRequestURL = NSURL(string: URL_SAVE_PROPERTY)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields

        let uid = FIRAuth.auth()?.currentUser?.uid

        let landlordID = uid
        let propertyAddress = address.text
        let monthlyRent = rentPerMonth.text
        let propertyDeposit = deposit.text
        let totalTenants = tenantNumber.text
        let numberOfRooms = bedroomNumber.text
        let numberOfBathrooms = bathroomNumber.text
        let availableDate = dateAvailable.text
        let milesToGu = milesToGU.text
        let lease = leaseLength.text
        
        
        if propertyAddress == "" || monthlyRent == "" || propertyDeposit == "" || totalTenants == "" || numberOfRooms == "" || numberOfBathrooms == "" || availableDate == "" || milesToGu == "" || lease == ""
        {
            let alert = UIAlertController(title: "Empty Fields", message:"Make sure you have entered information for all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            self.present(alert, animated: true){}
            
        }
        else {
        
            //post parameter
            //concatenating keys and values from text field

            let postParameters="landlord_id="+landlordID!+"&address="+propertyAddress!+"&rent_per_month="+monthlyRent!+"&deposit="+propertyDeposit!+"&total_tenants="+totalTenants!+"&number_of_rooms="+numberOfRooms!+"&number_of_bathrooms="+numberOfBathrooms!+"&date_available="+availableDate!+"&miles_to_gu="+milesToGu!+"&lease_length="+lease!;
            
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
            rentPerMonth.text = ""
            deposit.text = ""
            tenantNumber.text = ""
            bedroomNumber.text = ""
            bathroomNumber.text = ""
            milesToGU.text = ""
            dateAvailable.text = ""
            leaseLength.text = ""

        }
    }

    
    /*
     the variable 'maxID' holds the current max property id as an Int before a new property is added
     the variable 'propertyMaxID' holds the actual max property id as an Int after the new property is added since I just added 1 to 'maxID'
    */
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
        print("insidePictures")
        print(maxID)
        print(propertyMaxID)

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
    
    func logout(_ sender : UIButton) {
        if FIRAuth.auth() != nil {
            
            do {
                try FIRAuth.auth()?.signOut()
                print("the user is logged out")
            } catch let error as NSError {
                print(error.localizedDescription)
                print("the current user id is \(FIRAuth.auth()?.currentUser?.uid)")
            }
            do {
                try GIDSignIn.sharedInstance().signOut()
                print("Google signed out")
            } catch let error as NSError {
                print(error.localizedDescription)
                print("Error logging out of google")
            }
            FBSDKLoginManager().logOut()
            print("Facebook signed out")
            
        }
        
        
        let initialViewController = UIStoryboard(name: "Main", bundle:nil).instantiateInitialViewController()! as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
