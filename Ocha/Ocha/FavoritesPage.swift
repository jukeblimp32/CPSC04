//
//  FavoritesPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/11/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class FavoritesPage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet var favoritesMap: UIButton!
    @IBOutlet weak var favoritesList: UITableView!
    let getFavorites = "http://147.222.165.203/MyWebService/api/DisplayFavorites.php"
    var favoriteListings = [Listing]()
    var valueTopass : String!
    var downloadURL = ""
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        //refreshControl?.addTarget(self, action: Selector("handleRefresh:"), for: UIControlEvents.valueChanged)
        
        refreshControl.addTarget(self, action: #selector(FavoritesPage.handleRefresh(_:)), for: .valueChanged)
        
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
        
        favoritesMap.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (5/100), width: view.frame.width * (80/100), height: (view.frame.height) * (10/100))
        
        favoritesList.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (15/100), width: view.frame.width * (80/100), height: (view.frame.height) * (85/100))
        self.favoritesList.register(ListingTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        favoritesList.delegate = self
        favoritesList.dataSource = self
        favoritesList.reloadData()
        
        let viewTitle = UILabel()
  
        favoritesList.addSubview(refreshControl)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        favoriteListings.removeAll()
        loadListingViews()
        favoritesList.reloadData()
    }
    
    func handleRefresh(_ sender : UIRefreshControl) {
        favoriteListings.removeAll()
        loadListingViews()
        refreshControl.endRefreshing()
    }
    
/*    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        let barViewControllers = self.tabBarController?.viewControllers
        let svc = barViewControllers![0] as! StudentHomePage
        self.favoriteListings = svc.favoriteListings
    }*/
    
    func loadListingViews(){
        //create NSURL
        let getRequestURL = NSURL(string: getFavorites)
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
                let favorites: NSArray = propertyJSON["favorites"] as! NSArray
                
                let uid = FIRAuth.auth()?.currentUser?.uid
                
                //looping through all the objects in the array
                DispatchQueue.main.async(execute: {
                    for i in 0 ..< favorites.count{
                        //Getting data from each listing and saving to vars

                        let propIdValue = favorites[i] as? NSDictionary
                        let propertyID = propIdValue?["property_id"] as! Int
                        let landlordIdValue = favorites[i] as? NSDictionary
                        let landlordID = landlordIdValue?["landlord_id"] as! String
                        let addressValue = favorites[i] as? NSDictionary
                        let address = addressValue?["address"] as! String
                        let dateValue = favorites[i] as? NSDictionary
                        let date = dateValue?["date_available"] as! String
                        let milesValue = favorites[i] as? NSDictionary
                        let milesToGu = milesValue?["miles_to_gu"] as! String
                        let rentValue = favorites[i] as? NSDictionary
                        let rentPerMonth = rentValue?["rent_per_month"] as! String
                        let depositValue = favorites[i] as? NSDictionary
                        let deposit = depositValue?["deposit"] as! String
                        let roomsValue = favorites[i] as? NSDictionary
                        let roomNumber = roomsValue?["number_of_rooms"] as! String
                        let bathroomValue = favorites[i] as? NSDictionary
                        let bathroomNumber = bathroomValue?["number_of_bathrooms"] as! String
                        let leaseValue = favorites[i] as? NSDictionary
                        let lease = leaseValue?["lease_length"] as! String
                        let propertyTypeValue = favorites[i] as? NSDictionary
                        let propertyType = propertyTypeValue?["property_type"] as! String
                        let availabilityValue = favorites[i] as? NSDictionary
                        let available = availabilityValue?["availability"] as! String
                        let petValue = favorites[i] as? NSDictionary
                        let pets = petValue?["pets"] as! String
                        let descriptionValue = favorites[i] as? NSDictionary
                        let description = descriptionValue?["description"] as! String
                        let userIdValue = favorites[i] as? NSDictionary
                        let userID = userIdValue?["user_id"] as! String
                        let phoneValue = favorites[i] as? NSDictionary
                        let phoneNumber = phoneValue?["phone_number"] as! String
                        let emailValue = favorites[i] as? NSDictionary
                        let email = emailValue?["email"] as! String
 
                        if userID == uid {
                            let favoriteListing = Listing(propertyID: propertyID, landlordID: landlordID, address: address, dateAvailable: date, milesToGU: milesToGu, numberOfRooms: roomNumber, bathroomNumber : bathroomNumber, leaseLength : lease, monthRent: rentPerMonth, deposit: deposit, houseImage: nil, propertyType: propertyType, pets: pets, availability: available, description : description, phoneNumber : phoneNumber, email: email, userID: userID)
                            self.favoriteListings.append(favoriteListing)
                        }
                        
                        // Update our table
                        DispatchQueue.main.async(execute: {
                            self.favoritesList.reloadData()
                        })
                    }
                })
            }
            catch {
                print(error)
            }
        }
        getTask.resume()
    }

    
    /*
     When a listing cell is clicked on the homepage, this function
     sends the cell information and saves them as variables in
     the class ListingPage. The listing page will then show
     information that corresponds to the selected cell.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "showDetailFavorite",
            //Sets the page to be loaded as ListingPage
            let destination = segue.destination as? FavoriteListingPage,
            //Gets the selected cell index
            let cellIndex = favoritesList.indexPathForSelectedRow?.row
        {
            //Setting the variables in the listing class to the cell info
            destination.address = favoriteListings[cellIndex].address
            destination.rent = favoriteListings[cellIndex].monthRent
            destination.distance = favoriteListings[cellIndex].milesToGU
            destination.rooms = favoriteListings[cellIndex].numberOfRooms
            // Pass the imageUrl just to ensure that the image loads
            destination.imageUrl = favoriteListings[cellIndex].imageUrl
            destination.email = favoriteListings[cellIndex].email
            destination.dateAvailable = favoriteListings[cellIndex].dateAvailable
            destination.leaseLength = favoriteListings[cellIndex].leaseLength
            destination.bathroomNumber = favoriteListings[cellIndex].bathroomNumber
            destination.deposit = favoriteListings[cellIndex].deposit
            destination.pets = favoriteListings[cellIndex].pets
            destination.availability = favoriteListings[cellIndex].availability
            destination.propDescription = favoriteListings[cellIndex].description
            destination.propertyType = favoriteListings[cellIndex].propertyType
            destination.phoneNumber = favoriteListings[cellIndex].phoneNumber
            destination.propertyID = favoriteListings[cellIndex].propertyID
        }
        if segue.identifier == "favoritesMap",
            let destination = segue.destination as? FavoritesMap {
            destination.favListings = favoriteListings
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteListings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ListingTableViewCell"
        let cell = self.favoritesList.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as! ListingTableViewCell
        
        cell.favoriteButton.setImage(UIImage(named: "emptyStar"), for: UIControlState.normal)
        cell.favoriteButton.setImage(UIImage(named: "filledStar"), for: UIControlState.selected)
        cell.favoriteButton.isSelected = true
        
        let listing = favoriteListings[indexPath.row]
        
        cell.listing = listing
        cell.propertyAddress.text = listing.address
        cell.propertyDistance.text = String(listing.milesToGU)
        cell.propertyRent.text = String(listing.monthRent)
        cell.propertyRooms.text = String(listing.numberOfRooms)
        
        cell.propertyImage.image = listing.houseImage
        //cell.propertyImage.contentMode = .scaleAspectFill
        
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

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.favoritesList.frame.height / 4.0
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
