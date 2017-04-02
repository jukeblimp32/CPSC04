//
//  LandlordHomePage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/3/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LandlordHomePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var propertiesList: UITableView!
    
    let getProperties = "http://147.222.165.203/MyWebService/api/editDisplayProperties.php"
    var listings = [Listing]()
    var status = [String]()
    var downloadURL = ""
    var downloadURL2 = ""
    var downloadURL3 = ""
    var downloadURL4 = ""
    var downloadURL5 = ""
    var refreshControl : UIRefreshControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        logOutDeletedUser()
        self.propertiesList.register(LandlordTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LandlordHomePage.handleRefresh(_:)), for: .valueChanged)
        
        // Initialize our table
        propertiesList.frame = CGRect(x: (view.frame.width) * (0/100), y: (view.frame.height) * (10/100), width: view.frame.width, height: (view.frame.height) * (90/100))
        propertiesList.delegate = self
        propertiesList.dataSource = self
        propertiesList.reloadData()
        propertiesList.addSubview(refreshControl)
        
        //}
        
        let viewTitle = UILabel()
        
        var headerLabel = UILabel()
        headerLabel.text = "My Listings"
        headerLabel.font = UIFont(name: headerLabel.font.fontName, size: 24)
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.textColor = UIColor.white
        headerLabel.frame = CGRect(x: (view.frame.width) * (35/100), y: (view.frame.height) * (1/100), width: view.frame.width * (30/100), height: (view.frame.height) * (10/100))
        view.addSubview(headerLabel)

        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showDetailLandlord",
            let destination = segue.destination as? LandlordListingPage,
            let blogIndex = propertiesList.indexPathForSelectedRow?.row
        {
            destination.address = listings[blogIndex].address
            destination.rent = listings[blogIndex].monthRent
            destination.distance = listings[blogIndex].milesToGU
            destination.rooms = listings[blogIndex].numberOfRooms
            destination.imageUrl = listings[blogIndex].imageUrl
            destination.imageUrl2 = listings[blogIndex].imageUrl2
            destination.imageUrl3 = listings[blogIndex].imageUrl3
            destination.imageUrl4 = listings[blogIndex].imageUrl4
            destination.imageUrl5 = listings[blogIndex].imageUrl5
            destination.email = listings[blogIndex].email
            destination.propertyID = listings[blogIndex].propertyID
            destination.dateAvailable = listings[blogIndex].dateAvailable
            destination.leaseLength = listings[blogIndex].leaseLength
            destination.bathroomNumber = listings[blogIndex].bathroomNumber
            destination.deposit = listings[blogIndex].deposit
            destination.pets = listings[blogIndex].pets
            destination.availability = listings[blogIndex].availability
            destination.propDescription = listings[blogIndex].description
            destination.propertyType = listings[blogIndex].propertyType
            destination.phoneNumber = listings[blogIndex].phoneNumber
            
            destination.listingStatus = status[blogIndex]
        }
    }
    
    func handleRefresh(_ sender : UIRefreshControl) {
        listings.removeAll()
        status.removeAll()
        loadListingViews()
        propertiesList.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    func loadListingViews(){
        
        //create NSURL
        let getRequestURL = NSURL(string: getProperties)
        
        //creating NSMutableURLRequest
        let getRequest = NSMutableURLRequest(url:getRequestURL! as URL)
        
        //setting the method to GET
        getRequest.httpMethod = "GET"
        
        //task to be sent to the GET request
        let getTask = URLSession.shared.dataTask(with: getRequest as URLRequest){
            data,response,error in
            
            if error != nil{
                print("error is \(error)")
                return;
            }
            do{
                //converting response to a NSDictionary
                var propertyJSON : NSDictionary!
                propertyJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //getting the JSON array teams from the response
                let properties: NSArray = propertyJSON["editProperties"] as! NSArray
                
                let uid = FIRAuth.auth()?.currentUser?.uid
                
                //looping through all the json objects in the array properties
                DispatchQueue.main.async(execute: {
                    for i in 0 ..< properties.count{
                        //getting the data at each index
                        let propIdValue = properties[i] as? NSDictionary
                        let propertyID = propIdValue?["property_id"] as! Int
                        let landlordIdValue = properties[i] as? NSDictionary
                        let landlordID = landlordIdValue?["landlord_id"] as! String
                        let addressValue = properties[i] as? NSDictionary
                        let address = addressValue?["address"] as! String
                        let dateValue = properties[i] as? NSDictionary
                        let date = dateValue?["date_available"] as! String
                        let milesValue = properties[i] as? NSDictionary
                        let milesToGu = milesValue?["miles_to_gu"] as! String
                        let rentValue = properties[i] as? NSDictionary
                        let rentPerMonth = rentValue?["rent_per_month"] as! String
                        let depositValue = properties[i] as? NSDictionary
                        let deposit = depositValue?["deposit"] as! String
                        let roomsValue = properties[i] as? NSDictionary
                        let roomNumber = roomsValue?["number_of_rooms"] as! String
                        let bathroomValue = properties[i] as? NSDictionary
                        let bathroomNumber = bathroomValue?["number_of_bathrooms"] as! String
                        let leaseValue = properties[i] as? NSDictionary
                        let lease = leaseValue?["lease_length"] as! String
                        let propertyTypeValue = properties[i] as? NSDictionary
                        let propertyType = propertyTypeValue?["property_type"] as! String
                        let petValue = properties[i] as? NSDictionary
                        let pets = petValue?["pets"] as! String
                        let availabilityValue = properties[i] as? NSDictionary
                        let availability = availabilityValue?["availability"] as! String
                        let descriptionValue = properties[i] as? NSDictionary
                        let description = descriptionValue?["description"] as! String
                        let phoneNumberValue = properties[i] as? NSDictionary
                        let phoneNumber = phoneNumberValue?["phone_number"] as! String
                        let emailValue = properties[i] as? NSDictionary
                        let email = emailValue?["email"] as! String
                        let statusValue = properties[i] as? NSDictionary
                        let status = statusValue?["status"] as! String
                        
                        if landlordID == uid {
                        
                            let listing = Listing(propertyID: propertyID, landlordID: landlordID, address: address, dateAvailable: date, milesToGU: milesToGu, numberOfRooms: roomNumber, bathroomNumber: bathroomNumber, leaseLength : lease, monthRent: rentPerMonth, deposit : deposit, houseImage: nil, propertyType: propertyType, pets: pets, availability: availability, description: description, phoneNumber: phoneNumber, email : email,  userID: "")
                            self.listings.append(listing)
                            self.status.append(status)
                        }
                        
                        // Update our table
                        DispatchQueue.main.async(execute: {
                            self.propertiesList.reloadData()
                        })
                    }
                    
                })
                
            }catch{
                print(error)
            }
        }
        getTask.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listings.removeAll()
        status.removeAll()
        loadListingViews()
        propertiesList.reloadData()
        print("View will appear saved us")
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
    
    func logout(){
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "LandlordTableViewCell"
        let cell = self.propertiesList.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as! LandlordTableViewCell
        
        
        let listing = listings[indexPath.row]
        let listingStatus = status[indexPath.row]
        
        cell.listing = listing
        cell.propertyAddress.text = listing.address
        cell.propertyDistance.text = String(listing.milesToGU)
        cell.propertyRent.text = String(listing.monthRent)
        cell.propertyRooms.text = String(listing.numberOfRooms)
        cell.propertyImage.image = listing.houseImage
        cell.propertyStatus.text = listingStatus
        cell.favoriteButton.isHidden = true

        print(indexPath.row)
        print (listingStatus)
        
        // Make opaque if closed
        if (listing.availability == "Closed" || listing.availability == " Closed")
        {
            if (listingStatus == "Pending" || listingStatus == " Pending")
            {
                print("We are here")
                cell.favoriteButton.backgroundColor = UIColor.init(red: 0.9, green: 0.0, blue: 0.0, alpha: 0.4)
            }
            else if (listingStatus == "Editing" || listingStatus == " Editing")
            {
                cell.backgroundColor = UIColor.init(red: (230.0 / 255), green: (223.0 / 255), blue: (67.0 / 255), alpha: 0.7)
            }
            else
            {
                cell.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.4)
            }
            cell.propertyImage.alpha = 0.2
            cell.propertyAddress.alpha = 0.2
            cell.propertyDistance.alpha = 0.2
            cell.propertyRent.alpha = 0.2
            cell.propertyRooms.alpha = 0.2
            cell.rentLabel.alpha = 0.2
            cell.roomLabel.alpha = 0.2
            cell.distanceLabel.alpha = 0.2
        }
        else
        {
            if (listingStatus == "Pending" || listingStatus == " Pending")
            {
                cell.backgroundColor = UIColor.init(red: 0.9, green: 0.0, blue: 0.0, alpha: 0.4)
            }
            else if (listingStatus == "Editing" || listingStatus == " Editing")
            {
                cell.backgroundColor = UIColor.init(red: (230.0 / 255), green: (223.0 / 255), blue: (67.0 / 255), alpha: 0.7)
            }
            else
            {
                cell.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            cell.propertyImage.alpha = 1.0
            cell.propertyAddress.alpha = 1.0
            cell.propertyDistance.alpha = 1.0
            cell.propertyRent.alpha = 1.0
            cell.propertyRooms.alpha = 1.0
            cell.rentLabel.alpha = 1.0
            cell.roomLabel.alpha = 1.0
            cell.distanceLabel.alpha = 1.0
        }
        
        // Get reference to database.
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("listings").child(String(listing.propertyID)).observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshot = snapshot.value as? NSDictionary
            
            // Use default image if there is no image listing
            if(snapshot == nil)
            {
                self.downloadURL = ""
                self.downloadURL2 = ""
                self.downloadURL3 = ""
                self.downloadURL4 = ""
                self.downloadURL5 = ""
                
            }
            else
            {
                // Set the download URL and download the image
                self.downloadURL = snapshot?["image1"] as! String
                listing.imageUrl = self.downloadURL
                self.downloadURL2 = snapshot?["image2"] as! String
                listing.imageUrl2 = self.downloadURL2
                self.downloadURL3 = snapshot?["image3"] as! String
                listing.imageUrl3 = self.downloadURL3
                self.downloadURL4 = snapshot?["image4"] as! String
                listing.imageUrl4 = self.downloadURL4
                self.downloadURL5 = snapshot?["image5"] as! String
                listing.imageUrl5 = self.downloadURL5
                
                cell.propertyImage.loadCachedImages(url: self.downloadURL)
                listing.houseImage = cell.propertyImage.image
            }
            
        })

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.propertiesList.frame.height / 4.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // Logs out and deletes blocked users
    func logOutDeletedUser(){
        // Get our user
        if let user = FIRAuth.auth()?.currentUser {
            // Get a snapshot
            FIRDatabase.database().reference().child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    // If they are blocked, delete the account
                    if dictionary["type"] as? String == "Block"{
                        FIRDatabase.database().reference().child("users").child(user.uid).removeValue()
                        user.delete { error in
                            if let error = error {
                                print(error)
                            } else {
                                print("You've been deleted")
                                self.deletedAlert()
                                self.logout()
                            }
                        }
                    }
                }
            }, withCancel: nil)
        }
        
    }
    
    func deletedAlert()
    {
        let alertVC = UIAlertController(title: "Deleted", message: "Your account has been deleted by the administrator. Create a new one if you wish to continue using Ocha.", preferredStyle: .alert)
        let alertActionOkay = UIAlertAction(title: "Okay", style: .default)
        alertVC.addAction(alertActionOkay)
        self.present(alertVC, animated: true, completion: nil)
    }

    
    
}

