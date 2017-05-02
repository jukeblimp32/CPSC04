//
//  ListingPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import MessageUI
import Firebase
import GoogleMaps
import CoreLocation

class ListingPage: UITableViewController, MFMailComposeViewControllerDelegate{
    
    let createFavorites = "http://147.222.165.203/MyWebService/api/CreateFavorite.php"
    let removeFavorites = "http://147.222.165.203/MyWebService/api/RemoveFavorites.php"

    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    var imageUrl = ""
    var imageUrl2 = ""
    var imageUrl3 = ""
    var imageUrl4 = ""
    var imageUrl5 = ""
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
    var favoritePropIDs = [Int]()
    var propLat : Double = 0
    var propLong : Double = 0
    
    var property = [Properties]()

 
    @IBOutlet var myView: GMSMapView!

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var dateAvailableLabel: UILabel!
    @IBOutlet var pictureScrollView: UIScrollView!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var bedroomLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var petsLabel: UILabel!
    @IBOutlet var leaseLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var rentLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var propertyImage: UIImageView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var pictureCell: UITableViewCell!
    @IBOutlet weak var toHomePageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let screenScale = view.frame.height / 568.0
        fillMapView()
        addressLabel.text = address
        distanceLabel.text = "Distance from Gonzaga: " + distance + " mile(s)"
        phoneLabel.text = "Phone Number: " + phoneNumber
        petsLabel.text = "Pets allowed: " + pets
        leaseLabel.text = "Lease Terms: " + leaseLength
        descriptionField.text = propDescription
        dateAvailableLabel.text = "Date Available: " + dateAvailable + "          Availability: " + availability
        bedroomLabel.text = "Bedrooms: " + rooms + "          Bathrooms: " + bathroomNumber
        rentLabel.text = "Rent: " + rent + "          Deposit: " + deposit
        typeLabel.text = "Property Type: " + propertyType
        emailLabel.text = "Email: " + email
        addressLabel.adjustsFontSizeToFitWidth = true
        typeLabel.adjustsFontSizeToFitWidth = true
        emailLabel.adjustsFontSizeToFitWidth = true
        dateAvailableLabel.adjustsFontSizeToFitWidth = true
        bedroomLabel.adjustsFontSizeToFitWidth = true
        rentLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.adjustsFontSizeToFitWidth = true
        phoneLabel.adjustsFontSizeToFitWidth = true
        petsLabel.adjustsFontSizeToFitWidth = true
        leaseLabel.adjustsFontSizeToFitWidth = true
        loadPictures()
        initializeLabels()
        favoriteButton.backgroundColor = UIColor.white
        
        myView.frame = CGRect(x:0, y: 0, width : view.frame.width, height: view.frame.height * 0.5)
        
        // Make attributed text to create link
        let mutableText = NSMutableAttributedString(string: "Email: " + email, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18 * screenScale)])
        // Underline the email
        mutableText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 7, length: mutableText.length - 7))
        // Color the email
        mutableText.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 30.0/255, green: 52.0/255, blue: 75.0/255, alpha: 1), range:  NSRange(location: 7, length: mutableText.length - 7))
        // Add interaction
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ListingPage.openUpEmail)))
        emailLabel.attributedText = mutableText
        //view.addSubview(emailLabel)
        
        
        let phoneMutableText = NSMutableAttributedString(string: "Phone Number: " + phoneNumber, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18 * screenScale)])
        // Underline the email
        phoneMutableText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 14, length: phoneMutableText.length - 14))
        // Color the email
        phoneMutableText.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 30.0/255, green: 52.0/255, blue: 75.0/255, alpha: 1), range:  NSRange(location: 14, length: phoneMutableText.length - 14))
        // Add interaction
        phoneLabel.isUserInteractionEnabled = true
        phoneLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ListingPage.openPhone)))
        phoneLabel.attributedText = phoneMutableText

        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        if favoritePropIDs.contains(propertyID) {
            favoriteButton.setImage(UIImage(named: "filledStar"), for: UIControlState.normal)
        }
        else {
            favoriteButton.setImage(UIImage(named: "emptyStar"), for: UIControlState.normal)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionField.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func initializeLabels(){
        let screenScale = view.frame.height / 568.0
        addressLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        addressLabel.sizeToFit()
        
        distanceLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        distanceLabel.sizeToFit()
        
        phoneLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        phoneLabel.sizeToFit()
        
        petsLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        petsLabel.sizeToFit()
        
        leaseLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        leaseLabel.sizeToFit()
        
        descriptionField.font = UIFont.systemFont(ofSize: 18 * screenScale)
        descriptionField.sizeToFit()
        
        dateAvailableLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        dateAvailableLabel.sizeToFit()
        
        bedroomLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        bedroomLabel.sizeToFit()
        
        rentLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        rentLabel.sizeToFit()
        
        typeLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        typeLabel.sizeToFit()
        
    }
    
    func fillMapView() {
        let propAddress = self.address
        let propRent = self.rent
        let location = propAddress + ", Spokane, WA, USA"
        getLatLngForZip(address: location, rent: propRent)
        if(property.isEmpty) {
            self.myView.camera = GMSCameraPosition.camera(withLatitude: 47.667160, longitude: -117.402342, zoom: 14)
 
        }
        else {
            self.myView.camera = GMSCameraPosition.camera(withLatitude: propLat, longitude: propLong, zoom: 14)
        }
        let currentProperty = CLLocationCoordinate2DMake(47.667160, -117.402342)
        // Creates a marker in the center of the map.
        let marker = GMSMarker(position: currentProperty)
        marker.title = "Gonzaga University"
        marker.snippet = "College Hall"
        marker.map = myView
        
        for item in property{
            print(item.name)
            print(item.location)
            print(item.zoom)
            
            let marker = GMSMarker(position: item.location)
            marker.title = item.name
            marker.snippet = ("Monthly Rent: $"+item.rent)
            marker.map = myView
        }

        self.tableView.reloadData()
        
    }
  
    func getLatLngForZip(address: String, rent : String){
        let key = "AIzaSyCoeK0AFvWvqHTIHOrlzvOKK2YeaoGa7Gk"
        
        let url : NSString = "\(baseUrl)address=\(address)&key=\(key)" as NSString
        let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        
        let data = NSData(contentsOf: searchURL as URL)
        let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        
        if let results = json["results"] as? [[String: AnyObject]] {
            if(results.count == 0) {
                return
            }
            let result = results[0]
            if let geometry = result["geometry"] as? [String:AnyObject] {
                if let location = geometry["location"] as? [String:Double] {
                    let lat = location["lat"]
                    let lon = location["lng"]
                    let latitude = Double(lat!)
                    let longitude = Double(lon!)
                    propLat = latitude
                    propLong = longitude
                    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                    let prop = Properties(name: address, location: coordinates, zoom: 14, rent: rent)
                    print("added prop")
                    print (prop)
                    self.property.append(prop)
                    print("OVERHERE")
                    print("\n\(latitude), \(longitude)")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "seeReviews",
            let destination = segue.destination as? StudentPropertyReviews
            
        {
            destination.address = address
            destination.rent = rent
            destination.rooms = rooms
            destination.distance = distance
            destination.imageUrl = imageUrl
            destination.imageUrl2 = imageUrl2
            destination.imageUrl3 = imageUrl3
            destination.imageUrl4 = imageUrl4
            destination.imageUrl5 = imageUrl5
            destination.propertyID = propertyID
            destination.leaseLength = leaseLength
            destination.dateAvailable = dateAvailable
            destination.bathroomNumber = bathroomNumber
            destination.deposit = deposit
            destination.email = email
            destination.pets = pets
            destination.availability = availability
            destination.propDescription = propDescription
            destination.phoneNumber = phoneNumber
            destination.favoritePropIDs = favoritePropIDs
            
        }
    }
    
    func openUpEmail(sender: UITapGestureRecognizer){
        let emailsize = (emailLabel.attributedText?.length)! - 7
        // Set the range of the email. Subtract one to avoid index problems
        let emailRange = NSRange(location: 7, length: emailsize - 1)
        let tapLocation = sender.location(in: emailLabel)
        let tapindex = emailLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        // Only open email if the email address was selected
        if tapindex >= emailRange.location && tapindex < (emailRange.location + emailRange.length){
            // Can only send email if the device has mail set up
            if(MFMailComposeViewController.canSendMail())
            {
                // Address the email
                let editComposerVC = MFMailComposeViewController()
                editComposerVC.mailComposeDelegate = self
                editComposerVC.setToRecipients([email])
                editComposerVC.setSubject("Regarding Your Property at \(address)")
                self.present(editComposerVC, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Email Not Setup", message:"Please set up your email in order to contact landlords.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                self.present(alert, animated: true){}
            }

        }
    }
    
    
    func stripPhoneNumber(number : String) ->String {
        var editedNumber : String = ""
        for number in phoneNumber.characters {
            let num = String(number)
            if num == "1" || num == "2" || num == "3" || num == "4" || num == "5" || num == "6" || num == "7" || num == "8" || num == "9" || num == "0" {
                editedNumber += num
            }
        }
        print(editedNumber)
        return editedNumber
    }
    
    func openPhone(sender: UITapGestureRecognizer){
        let phoneSize = (phoneLabel.attributedText?.length)! - 14
        // Set the range of the email. Subtract one to avoid index problems
        let phoneRange = NSRange(location: 14, length: phoneSize - 1)
        let tapLocation = sender.location(in: phoneLabel)
        let tapindex = phoneLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        // Only open email if the email address was selected
        if tapindex >= phoneRange.location && tapindex < (phoneRange.location + phoneRange.length){
            
            let editNumber = stripPhoneNumber(number: phoneNumber)
            
            
            if let phoneCallURL = URL(string: "telprompt://\(editNumber)") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    
    func loadPictures() {
        let myImages = [self.imageUrl, self.imageUrl2, self.imageUrl3, self.imageUrl4, self.imageUrl5]
        
        //Put an offset between each picture
        let offset = view.frame.width * (20/100)
        let size = view.frame.width * (60/100)
        let imageWidth : CGFloat = size
        let imageHeight : CGFloat = size
        var xPosition : CGFloat = offset
        var scrollViewSize : CGFloat = 0

        pictureScrollView.frame = CGRect(x:0, y: 0, width : view.frame.width, height: imageHeight)
        
        for image in myImages {
            let myImageView : UIImageView = UIImageView()
            myImageView.contentMode = .scaleAspectFit
            myImageView.clipsToBounds = true
            myImageView.loadCachedImages(url: image)
            myImageView.frame.size.width = imageWidth
            myImageView.frame.size.height = imageHeight
            myImageView.frame.origin.x = xPosition
            myImageView.frame.origin.y = 0
            
            pictureScrollView.addSubview(myImageView)
            xPosition += imageWidth + offset
            scrollViewSize += imageWidth + offset
            
        }
        scrollViewSize += offset
        
        pictureScrollView.contentSize = CGSize(width: scrollViewSize, height: imageHeight)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == 2{
            return view.frame.width * (65/100)
        }
        if section == 0 && row == 3{
            return view.frame.height * (7/100)
        }
        if section == 0 && row == 4{
            return view.frame.height * (7/100)
        }
        if section == 1{
            return view.frame.height * (7/100)
        }
        if section == 2 && row == 0 {
            return view.frame.height * (30/100)
        }
        if section == 3 {
            return view.frame.height * (7/100)
        }
        if section == 4 {
            return view.frame.height * 0.5
        }
        if section == 5{
            return view.frame.height * (7/100)
        }
        return UITableViewAutomaticDimension
    }

    
    @IBAction func starPressed(_ sender: UIButton) {
        if (sender.currentImage?.isEqual(UIImage(named: "filledStar")))!{
            sender.setImage(UIImage(named: "emptyStar"), for: UIControlState.normal)
            removeFavorite()
        }
        else
        {
            sender.setImage(UIImage(named: "filledStar"), for: UIControlState.normal)
            createFavorite()
        }
    }
    
    
    func createFavorite(){
        //created NSURL
        let saveRequestURL = NSURL(string: createFavorites)
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields
        
        //let landlordID = self.firstName
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        
        //post parameter
        //concatenating keys and values from text field
        let propID = propertyID
        let userID = uid
        let postParameters="property_id="+String(propID)+"&user_id="+userID!;
        
        
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
    }
    
    func removeFavorite(){
        //created NSURL
        let saveRequestURL = NSURL(string: removeFavorites)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields
        
        //let landlordID = self.firstName
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        //post parameter
        //concatenating keys and values from text field
        let propID = propertyID
        let userID = uid
        let postParameters="property_id="+String(propID)+"&user_id="+userID!;
        
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // May need alert to stop from cancelling
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}
