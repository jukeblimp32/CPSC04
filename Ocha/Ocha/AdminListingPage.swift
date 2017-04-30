//
//  AdminListingPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class AdminListingPage: UITableViewController {
    
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
    var landlordID : String = ""
    var email : String = ""
    var propertyID : Int = 0
    var image : UIImage = UIImage(named: "default")!
    var propLat : Double = 0
    var propLong : Double = 0
    
    var property = [Properties]()
    
    let removeProperty = "http://147.222.165.203/MyWebService/api/RemoveProperty.php"
    let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    @IBOutlet var myView: GMSMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var propertyImage: UIImageView!
    @IBOutlet var dateAvailableLabel: UILabel!
    @IBOutlet var rentLabel: UILabel!
    @IBOutlet var bedroomLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var typeLabel: UILabel!
    
    @IBOutlet var pictureScrollView: UIScrollView!
    @IBOutlet var petsLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var leaseLabel: UILabel!
    @IBOutlet weak var toHomePageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myView.frame = CGRect(x:0, y: 0, width : view.frame.width, height: view.frame.height * 0.5)
        
        fillMapView()
        addressLabel.text = address
        typeLabel.text = "Property Type: " + propertyType
        distanceLabel.text = "Distance from Gonzaga: " + distance + " mile(s)"
        phoneLabel.text = "Phone Number: " + phoneNumber
        petsLabel.text = "Pets allowed: " + pets
        leaseLabel.text = "Lease Terms: " + leaseLength
        descriptionField.text = propDescription
        rentLabel.text = "Rent: " + rent
        emailLabel.text = "Email: " + email
        dateAvailableLabel.text = "Date Available: " + dateAvailable + "          Availability: " + availability
        bedroomLabel.text = "Bedrooms: " + rooms + "          Bathrooms: " + bathroomNumber
        rentLabel.text = "Rent: " + rent + "          Deposit: " + deposit
        addressLabel.adjustsFontSizeToFitWidth = true
        dateAvailableLabel.adjustsFontSizeToFitWidth = true
        typeLabel.adjustsFontSizeToFitWidth = true
        bedroomLabel.adjustsFontSizeToFitWidth = true
        rentLabel.adjustsFontSizeToFitWidth = true
        emailLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.adjustsFontSizeToFitWidth = true
        phoneLabel.adjustsFontSizeToFitWidth = true
        petsLabel.adjustsFontSizeToFitWidth = true
        leaseLabel.adjustsFontSizeToFitWidth = true
        loadPictures()
        initializeLabels()
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
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
        
        emailLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        emailLabel.sizeToFit()
        
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
    
    func loadPictures() {
        let myImages = [self.imageUrl, self.imageUrl2, self.imageUrl3, self.imageUrl4, self.imageUrl5]
        
        let offset = view.frame.width * (20/100)
        let size = view.frame.width * (60/100)
        let imageWidth : CGFloat = size
        let imageHeight : CGFloat = size
        var xPosition : CGFloat = offset
        var scrollViewSize : CGFloat = 0
        
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
    
    /* Deletes current listing from database */
    @IBAction func deleteListing(_ sender: Any) {
        // Create alert
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to permanently delete this listing?", preferredStyle: .alert)
        
        // Do nothing if we cancel
        let alertActionResend = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, delete the listing from the database
        let alertActionOkay = UIAlertAction(title: "Yes", style: .default){
            (_) in
            //created NSURL
            let saveRequestURL = NSURL(string: self.removeProperty)
            
            //creating NSMutableURLRequest
            let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
            
            //setting method to POST
            saveRequest.httpMethod = "POST"
            
            //getting values from text fields
            
            //let landlordID = self.firstName
            let postParameters="property_id="+String(self.propertyID);
            
            
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
            // Go back to homepage
            self.toHomePageButton.sendActions(for: .touchUpInside)
            
        }
        alertVC.addAction(alertActionResend)
        alertVC.addAction(alertActionOkay)
        self.present(alertVC, animated: true, completion: nil)

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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "EditAdminListing",
            //Sets the page to be loaded as ListingPage
            let destination = segue.destination as? EditAdminListing
            //Gets the selected cell index
            //Setting the variables in the listing class to the cell info
        {
            destination.address = address
            destination.rent = rent
            destination.bedroomNum = rooms
            destination.distance = distance
            destination.imageURL = imageUrl
            destination.imageURL2 = imageUrl2
            destination.imageURL3 = imageUrl3
            destination.imageURL4 = imageUrl4
            destination.imageURL5 = imageUrl5
            destination.propertyID = propertyID
            destination.leaseTerms = leaseLength
            destination.dateAvailable = dateAvailable
            destination.bathroomNum = bathroomNumber
            destination.deposit = deposit
            destination.email = email
            destination.pets = pets
            destination.availability = availability
            destination.propDescription = propDescription
            destination.phoneNumber = phoneNumber
            destination.propertyType = propertyType
            destination.landlordID = landlordID
            
        }
        if segue.identifier == "toAdminReviews",
            //Sets the page to be loaded as ListingPage
            let destination = segue.destination as? AdminPropertyReviews
            //Gets the selected cell index
            //Setting the variables in the listing class to the cell info
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
            destination.propertyType = propertyType
            destination.landlordID = landlordID
            
        }
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
