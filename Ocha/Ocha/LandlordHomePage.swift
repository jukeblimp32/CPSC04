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
    
    let getProperties = "http://147.222.165.203/MyWebService/api/DisplayProperties.php"
    var listings = [Listing]()
    var downloadURL = ""
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.propertiesList.register(ListingTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(LandlordHomePage.handleRefresh(_:)), for: .valueChanged)
        
        // Initialize our table
        propertiesList.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (10/100), width: view.frame.width * (80/100), height: (view.frame.height) * (90/100))
        propertiesList.delegate = self
        propertiesList.dataSource = self
        propertiesList.reloadData()
        propertiesList.addSubview(refreshControl)
        
        //}
        
        let viewTitle = UILabel()
        
        let toHomePageButton = UIButton()
        toHomePageButton.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (5/100), width: view.frame.width * (25/100) , height: 20)
        toHomePageButton.setTitle("Logout", for: UIControlState.normal)
        toHomePageButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        toHomePageButton.titleLabel?.textColor = UIColor.white
        toHomePageButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        toHomePageButton.layer.cornerRadius = 4
        toHomePageButton.addTarget(self, action: #selector(StudentHomePage.logout(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(toHomePageButton)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showDetailLandlord",
            let destination = segue.destination as? ListingPage,
            let blogIndex = propertiesList.indexPathForSelectedRow?.row
        {
            destination.address.text = listings[blogIndex].address
            destination.rent.text = listings[blogIndex].monthRent
            destination.distance.text = listings[blogIndex].milesToGU
            destination.rooms.text = listings[blogIndex].numberOfRooms
            destination.imageUrl = listings[blogIndex].imageUrl
            destination.image.image = listings[blogIndex].houseImage
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
        }
    }
    
    func handleRefresh(_ sender : UIRefreshControl) {
        listings.removeAll()
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
                let properties: NSArray = propertyJSON["properties"] as! NSArray
                
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
                        
                        
                        if landlordID == uid {
                        
                            let listing = Listing(propertyID: propertyID, landlordID: landlordID, address: address, dateAvailable: date, milesToGU: milesToGu, numberOfRooms: roomNumber, bathroomNumber: bathroomNumber, leaseLength : lease, monthRent: rentPerMonth, deposit : deposit, houseImage: nil, propertyType: propertyType, pets: pets, availability: availability, description: description, phoneNumber: phoneNumber,  userID: "")
                            self.listings.append(listing)
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
        loadListingViews()
        propertiesList.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ListingTableViewCell"
        let cell = self.propertiesList.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as! ListingTableViewCell
        
        
        let listing = listings[indexPath.row]
        
        cell.listing = listing
        cell.propertyAddress.text = listing.address
        cell.propertyDistance.text = String(listing.milesToGU)
        cell.propertyRent.text = String(listing.monthRent)
        cell.propertyRooms.text = String(listing.numberOfRooms)
        cell.propertyImage.image = listing.houseImage
        //cell.propertyImage.contentMode = .scaleAspectFill
        
        // Make opaque if closed
        if listing.availability == "Closed" || listing.availability == " Closed"
        {
            cell.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.4)
            cell.favoriteButton.alpha = 0.2
            cell.propertyImage.alpha = 0.2
            cell.propertyAddress.alpha = 0.2
            cell.propertyDistance.alpha = 0.2
            cell.propertyRent.alpha = 0.2
            cell.propertyRooms.alpha = 0.2
            cell.rentLabel.alpha = 0.2
            cell.roomLabel.alpha = 0.2
            cell.distanceLabel.alpha = 0.2
        }
        // Set to normal look if open
        else
        {
            cell.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.favoriteButton.alpha = 1.0
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
            }
            else
            {
                // Set the download URL and download the image
                self.downloadURL = snapshot?["image1"] as! String
                listing.imageUrl = self.downloadURL
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
        print("Hey")
    }
    
    
}

