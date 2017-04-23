//
//  ApproveListings.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/3/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GameplayKit

class ApproveNewListings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    
    @IBOutlet var propertiesList: UITableView!
    //propertiesList
    
    @IBOutlet weak var propertiesMsg: UILabel!
    let getProperties = "http://147.222.165.203/MyWebService/api/DisplayProperties.php"
    var listings = [Listing]()
    
    
    var valueTopass : String!
    var downloadURL = ""
    var downloadURL2 = ""
    var downloadURL3 = ""
    var downloadURL4 = ""
    var downloadURL5 = ""
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(StudentHomePage.handleRefresh(_:)), for: .valueChanged)
        
        self.propertiesList.register(ListingTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        // Initialize our table
        propertiesList.frame = CGRect(x: (view.frame.width) * (0/100), y: (view.frame.height) * (15/100), width: view.frame.width, height: (view.frame.height) * (85/100))
        propertiesList.delegate = self
        propertiesList.dataSource = self
        propertiesList.reloadData()
        propertiesList.addSubview(refreshControl)
        
        let viewTitle = UILabel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listings.removeAll()
        loadListingViews()
        propertiesList.reloadData()
        
    }
    
    func handleRefresh(_ sender : UIRefreshControl) {
        listings.removeAll()
        loadListingViews()
        refreshControl.endRefreshing()
    }
    
    
    /*
     When a listing cell is clicked on the homepage, this function
     sends the cell information and saves them as variables in
     the class ListingPage. The listing page will then show
     information that corresponds to the selected cell.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "ApproveListing",
            //Sets the page to be loaded as ListingPage
            let destination = segue.destination as? ApproveNewListingPage,
            //Gets the selected cell index
            let cellIndex = propertiesList.indexPathForSelectedRow?.row
        {
            //Setting the variables in the listing class to the cell info
            destination.address = listings[cellIndex].address
            destination.rent = listings[cellIndex].monthRent
            destination.distance = listings[cellIndex].milesToGU
            destination.rooms = listings[cellIndex].numberOfRooms
            destination.imageUrl = listings[cellIndex].imageUrl
            destination.imageUrl2 = listings[cellIndex].imageUrl2
            destination.imageUrl3 = listings[cellIndex].imageUrl3
            destination.imageUrl4 = listings[cellIndex].imageUrl4
            destination.imageUrl5 = listings[cellIndex].imageUrl5
            destination.leaseLength = listings[cellIndex].leaseLength
            destination.dateAvailable = listings[cellIndex].dateAvailable
            destination.bathroomNumber = listings[cellIndex].bathroomNumber
            destination.deposit = listings[cellIndex].deposit
            destination.email = listings[cellIndex].email
            destination.pets = listings[cellIndex].pets
            destination.availability = listings[cellIndex].availability
            destination.propDescription = listings[cellIndex].description
            destination.propertyType = listings[cellIndex].propertyType
            destination.phoneNumber = listings[cellIndex].phoneNumber
            destination.propertyID = listings[cellIndex].propertyID
            destination.landlordID = listings[cellIndex].landlordID
        }
    }
    
    /*
     This function loads the the listings from the database
     onto cells that contain summary info for each listing. The
     cells are displayed in a scrollable view on the student homepage.
     */
    func loadListingViews(){
        var tempListings = [(Int, Listing)]()
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
                DispatchQueue.main.async(execute: {
                    for i in 0 ..< properties.count{
                        //Getting data from each listing and saving to vars
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
                        let emailValue = properties[i] as? NSDictionary
                        let email = emailValue?["email"] as! String
                        let phoneNumberValue = properties[i] as? NSDictionary
                        let phoneNumber = phoneNumberValue?["phone_number"] as! String
                        let statusValue = properties[i] as? NSDictionary
                        let status = statusValue?["status"] as! String
                        
                        if (status == "Pending" || status == " Pending") {
                            let listing = Listing(propertyID: propertyID, landlordID: landlordID, address: address, dateAvailable : date, milesToGU: milesToGu, numberOfRooms: roomNumber, bathroomNumber: bathroomNumber, leaseLength: lease, monthRent: rentPerMonth, deposit : deposit, houseImage: nil, propertyType: propertyType, pets: pets, availability: availability, description: description, phoneNumber: phoneNumber, email : email, userID : "")
                        
                        
                            self.listings.append(listing)
                        }
                        
                        if(self.listings.count != 0){
                            self.propertiesList.isHidden = false
                            self.propertiesMsg.isHidden = true
                        }
                        else{
                            self.propertiesList.isHidden = true
                            self.propertiesMsg.isHidden = false
                        }
                        
                        //Update the tableview in student homepage to show the listing cells
                        DispatchQueue.main.async(execute: {
                            self.propertiesList.reloadData()
                        })
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.propertiesList.reloadData()
                    })
                    
                    
                    
                })
            }
            catch {
                print(error)
            }
        }
        getTask.resume()
    }
    
    
    /*
     Logs a user out of the app if they press the logout button, and
     returns them to the homepage.
     */
    func logout(_ sender : UIButton) {
        //Checks the credentials of the current user in firebase
        if FIRAuth.auth() != nil {
            //Tries to log the user out of firebase
            do {
                try FIRAuth.auth()?.signOut()
                print("the user is logged out")
                //If unsuccessful, prints out the error and the current user ID
            } catch let error as NSError {
                print(error.localizedDescription)
                print("the current user id is \(FIRAuth.auth()?.currentUser?.uid)")
            }
            //Tries to log the user out of Google
            do {
                try GIDSignIn.sharedInstance().signOut()
                print("Google signed out")
                //If unsuccessful, prints out the error
            } catch let error as NSError {
                print(error.localizedDescription)
                print("Error logging out of google")
            }
            //Logs out the user out of facebook
            FBSDKLoginManager().logOut()
            print("Facebook signed out")
        }
        //Instantiates the login page as the root
        let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()! as UIViewController
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.window?.rootViewController = initialViewController
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
        cell.favoriteButton.isHidden = true
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
                print("I was nil")
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
        
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! ListingTableViewCell
        valueTopass = currentCell.propertyAddress.text
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
