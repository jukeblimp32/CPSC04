//
//  StudentHomePage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/3/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class StudentHomePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Properties
    @IBOutlet weak var propertiesList: UITableView!
    let getProperties = "http://147.222.165.203/MyWebService/api/DisplayProperties.php"
    let propertyDetails = "http://147.222.165.203/MyWebService/api/PropertyDetails.php"
    let getFavorites = "http://147.222.165.203/MyWebService/api/DisplayFavorites.php"
    
    var listings = [Listing]()
    var favoriteListings = [FavoriteListings]()
    
    var valueTopass : String!
    var downloadURL = ""
    var filters = [String]()
    var filterLabels = [UIButton]()
    var positionInLabels = 0
    var refreshControl : UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        //refreshControl?.addTarget(self, action: Selector("handleRefresh:"), for: UIControlEvents.valueChanged)
        
        refreshControl.addTarget(self, action: #selector(StudentHomePage.handleRefresh(_:)), for: .valueChanged)
        
        self.propertiesList.register(ListingTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        // Initialize our table
        propertiesList.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (15/100), width: view.frame.width * (80/100), height: (view.frame.height) * (85/100))
        propertiesList.delegate = self
        propertiesList.dataSource = self
        propertiesList.reloadData()
        propertiesList.addSubview(refreshControl)

        let viewTitle = UILabel()
        
        let toHomePageButton = UIButton()
        toHomePageButton.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (4/100), width: view.frame.width * (25/100) , height: 20)
        toHomePageButton.setTitle("Logout", for: UIControlState.normal)
        toHomePageButton.titleLabel?.adjustsFontSizeToFitWidth = true
        toHomePageButton.titleLabel?.textColor = UIColor.white
        toHomePageButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        toHomePageButton.layer.cornerRadius = 4
        toHomePageButton.addTarget(self, action: #selector(StudentHomePage.logout(_:)), for: UIControlEvents.touchUpInside)
        
        // Set up filter labels
        initializeFilters()
        
        view.addSubview(toHomePageButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let barViewControllers = self.tabBarController?.viewControllers
        let svc = barViewControllers![1] as! SearchAndFilter
        self.filters = svc.filters
        
        /*
        let fav = barViewControllers![2] as! FavoritesPage
        self.favoriteListings = fav.favoriteListings
        */
        // Reset filters
        //filterLabels.removeAll()
        //print(filterLabels.count)
        //initializeFilters()
        //print(filterLabels.count)
        
        loadFilters()
        listings.removeAll()
        loadListingViews()
        propertiesList.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        positionInLabels = 0
        clearFilterLabels()
    }
    
    func handleRefresh(_ sender : UIRefreshControl) {
        listings.removeAll()
        loadListingViews()
        propertiesList.reloadData()
        refreshControl.endRefreshing()
    }
    
    func loadFilters(){
        // Don't load if no filters
        if(self.filters == [])
        {
            return
        }
        // Go through the list of filters. If a filter is "Any" don't label it.
        for index in 0 ..< self.filters.count{
            // Check that the first filter is not Any.
            if(index == 0 && !(self.filters[0] == "Any" && self.filters[1] == "Any")){
                // If not Any then add the upper bound and lower bound together
                let priceFilter = "x  Price: " + self.filters[0] + " - " + self.filters[1]
                // Set the label
                filterLabels[positionInLabels].setTitle(priceFilter, for: UIControlState.normal)
                filterLabels[positionInLabels].backgroundColor = UIColor.init(red: 214/255.0, green: 71/255.0, blue: 71/255.0, alpha: 1)
                // Move the current position in the labels
                positionInLabels += 1
            }
            // Check bed filter.
            else if(index == 2 && self.filters[2] != "Any"){
                let bedFilter = "x  Rooms: " + self.filters[2]
                filterLabels[positionInLabels].setTitle(bedFilter, for: UIControlState.normal)
                filterLabels[positionInLabels].backgroundColor = UIColor.init(red: 214/255.0, green: 71/255.0, blue: 71/255.0, alpha: 1)
                positionInLabels += 1
            }
            // Check that the bed distance is not at maximum
            /*************************************************
            * This value will likely need to change from  10
            *************************************************/
            else if(index == 3 && self.filters[3] != "30.0"){
                let distFilter = "x  Miles to GU: " + self.filters[3]
                filterLabels[positionInLabels].setTitle(distFilter, for: UIControlState.normal)
                filterLabels[positionInLabels].backgroundColor = UIColor.init(red: 214/255.0, green: 71/255.0, blue: 71/255.0, alpha: 1)

                positionInLabels += 1
            }
            // Check Property Type filter
            else if(index == 4 && self.filters[4] != "Any")
            {
                let propFilter = "x  Prop Type: " + self.filters[4]
                filterLabels[positionInLabels].setTitle(propFilter, for: UIControlState.normal)
                filterLabels[positionInLabels].backgroundColor = UIColor.init(red: 214/255.0, green: 71/255.0, blue: 71/255.0, alpha: 1)

                positionInLabels += 1
            }
            
        }
    }
    
    func initializeFilters()
    {
        // Initialize the labels
        for index in 0 ... 5 {
            let newLabel = UIButton()
            newLabel.setTitle("", for: UIControlState.normal)
            newLabel.titleLabel?.font = UIFont(name: (newLabel.titleLabel?.font.fontName)!, size: 12)
            newLabel.setTitleColor(UIColor.white, for: .normal)
            newLabel.titleLabel?.adjustsFontSizeToFitWidth = true
            newLabel.tag = index
            newLabel.layer.cornerRadius = 6
            newLabel.addTarget(self, action: #selector(StudentHomePage.deselectFilter(_:)), for: UIControlEvents.touchUpInside)
            //newLabel.textAlignment = .center
            
            // Set positions
            switch index{
            case 0:
                newLabel.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (9/100), width: view.frame.width * (23/100), height: (view.frame.height) * (2.5/100))
            case 1:
                newLabel.frame = CGRect(x: (view.frame.width) * (36/100), y: (view.frame.height) * (9/100), width: view.frame.width * (23/100), height: (view.frame.height) * (2.5/100))
            case 2:
                newLabel.frame = CGRect(x: (view.frame.width) * (62/100), y: (view.frame.height) * (9/100), width: view.frame.width * (23/100), height: (view.frame.height) * (2.5/100))
            case 3:
                newLabel.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (12/100), width: view.frame.width * (23/100), height: (view.frame.height) * (2.5/100))
            case 4:
                newLabel.frame = CGRect(x: (view.frame.width) * (36/100), y: (view.frame.height) * (12/100), width: view.frame.width * (23/100), height: (view.frame.height) * (2.5/100))
            case 5:
                newLabel.frame = CGRect(x: (view.frame.width) * (62/100), y: (view.frame.height) * (12/100), width: view.frame.width * (23/100), height: (view.frame.height) * (2.5/100))
            default:
                newLabel.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (9/100), width: view.frame.width * (23/100), height: (view.frame.height) * (2.5/100))
            }
            filterLabels.append(newLabel)
            view.addSubview(newLabel)
        }
    }
    
    func clearFilterLabels()
    {
        for label in filterLabels{
            label.setTitle(" ", for: UIControlState.normal)
            label.backgroundColor = nil
            positionInLabels = 0

        }
    }
    
    func deselectFilter(_ sender : UIButton){
        // Only be able to remove if there is a filter
        if(sender.titleLabel?.text != nil && sender.titleLabel?.text != " ")
        {
            // Reset the filter in the list and clear button
            deleteFilter(filterTitle: (sender.titleLabel?.text)!)
            sender.setTitle(" ", for: UIControlState.normal)
            sender.backgroundColor = nil
            
            // Clear the last one to avoid duplicating
            filterLabels[positionInLabels - 1].setTitle(" ", for: UIControlState.normal)
            filterLabels[positionInLabels - 1].backgroundColor = nil
            positionInLabels = 0
            
            // Reload filters and refresh
            loadFilters()
            handleRefresh(refreshControl)
        }
        
        return
    }
    
    
    func deleteFilter(filterTitle: String){
        // Get reference to search and filter
        let barViewControllers = self.tabBarController?.viewControllers
        let svc = barViewControllers![1] as! SearchAndFilter
        
        if(filterTitle.contains("x  Price:")){
            filters[0] = "Any"
            svc.filters[0] = "Any"
            filters[1] = "Any"
            svc.filters[1] = "Any"
        }
        else if(filterTitle.contains("x  Rooms:")){
            filters[2] = "Any"
            svc.filters[2] = "Any"
        }
        else if(filterTitle.contains("x  Miles to GU:")){
            filters[3] = "30.0"
            svc.filters[3] = "30.0"
        }
        else if(filterTitle.contains("x  Prop Type:")){
            filters[4] = "Any"
            svc.filters[4] = "Any"
        }
    }
    

    
    /*
     When a listing cell is clicked on the homepage, this function
     sends the cell information and saves them as variables in 
     the class ListingPage. The listing page will then show 
     information that corresponds to the selected cell.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "showDetail",
            //Sets the page to be loaded as ListingPage
            let destination = segue.destination as? ListingPage,
            //Gets the selected cell index
            let cellIndex = propertiesList.indexPathForSelectedRow?.row
        {
            //Setting the variables in the listing class to the cell info
            destination.address.text = listings[cellIndex].address
            destination.rent.text = listings[cellIndex].monthRent
            destination.distance.text = listings[cellIndex].milesToGU
            destination.rooms.text = listings[cellIndex].numberOfRooms
            // Pass the imageUrl just to ensure that the image loads
            destination.imageUrl = listings[cellIndex].imageUrl
            destination.image.image = listings[cellIndex].houseImage
            destination.leaseLength = listings[cellIndex].leaseLength
            destination.dateAvailable = listings[cellIndex].dateAvailable
            destination.bathroomNumber = listings[cellIndex].bathroomNumber
            destination.deposit = listings[cellIndex].deposit
            destination.pets = listings[cellIndex].pets
            destination.availability = listings[cellIndex].availability
            destination.propDescription = listings[cellIndex].description
            destination.propertyType = listings[cellIndex].propertyType
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
                    

                        let listing = Listing(propertyID: propertyID, landlordID: landlordID, address: address, dateAvailable : date, milesToGU: milesToGu, numberOfRooms: roomNumber, bathroomNumber: bathroomNumber, leaseLength: lease, monthRent: rentPerMonth, deposit : deposit, houseImage: nil, propertyType: propertyType, pets: pets, availability: availability, description: description)

                        
                        let filterCounter = self.checkFilters(listing: listing)
                        
                        listing.counter = filterCounter
                        
                        tempListings.append((filterCounter, listing))
                        
                        
                        //Update the tableview in student homepage to show the listing cells
                        DispatchQueue.main.async(execute: {
                            self.propertiesList.reloadData()
                        })
                    }
                    tempListings.sort{Int($0.0) > Int($1.0)}
                    for item in tempListings{
                        self.listings.append(item.1)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                        self.propertiesList.reloadData()
                    })
                    print("favorited Properties")
                    self.favoritedProperties()
                })
            }
            catch {
                print(error)
            }
        }
        getTask.resume()
    }
    

    
    //Leah(:
    //have to first go to 'favorites' page and then back to home to get properties that are favorited by logged in user
    //because 'favoriteListings' gets filled when 'favoirtes' is visited
    //one thing to do if fill 'favoriteListing' array on 'studenthomepage' and then just pass the array from 'studenthomepage' to 'favoritesPage'
    //instead of right what we're doing right now, pasing in 'favoriteListing' from 'favoritesPage' to 'studenthomepage'
    //returns an array of all favorited properties by logged in user that are in the 'listings' array
    //called at the end of 'loadlistingview'
    func favoritedProperties() -> Array<Listing>{
        //array to hold all favorited properties that are in the current listings
        var favListings = [Listing]()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        //check if listings from 'listings' is in the 'favorites', all of the favorited properties
        for item1 in listings{
            let property1 : Int = Int(item1.propertyID)
            for item2 in favoriteListings{
                let favUserId : String = String(item2.userID)
                let property2 : Int = Int(item2.propertyID)
                if ((uid == favUserId) && (property1 == property2)){
                    favListings.append(item1)
                }
            }
        }
        print("this is favListings")
        print(favListings.count) //should be 1
        print(favListings)
        return favListings
    }
    
    func checkFilters(listing : Listing) -> Int{
        if (checkDefaults()) {
            return 0
        }
        else{
            var counter = 0
            counter += self.checkPriceRange(listing : listing)
            counter += self.checkBedrooms(listing : listing)
            counter += self.checkPropType(listing : listing)
            counter += self.checkDistance(listing : listing)
            return counter
        }

    }

    
    func checkDefaults() -> Bool {
        if (self.filters == []) {
            return true
        }
        return false
    }
    
    func checkPriceRange(listing : Listing) -> Int {
        //Both prices are Any (no preference)
        if ((self.filters[0] == "Any") && (self.filters[1] == "Any")) {
            return 0
        }
        
        //Listing has no proper rent value
        if (Int(listing.monthRent) == nil) {
            return 0
        }
        
        let listingRent : Int = Int(listing.monthRent)!
        
        //Just min is set to any
        if (self.filters[0] == "Any") {
            let max : Int = Int(self.filters[1])!
            if(listingRent <= max) {
                return 1
            }
            else {
                return 0
            }
        }
        
        //Just max is set to any
        if (self.filters[1] == "Any") {
            let min : Int = Int(self.filters[0])!
            if (listingRent >= min) {
                 return 1
            }
            else {
                return 0
            }
            
        }
        
        let min : Int = Int(self.filters[0])!
        let max : Int  = Int(self.filters[1])!
        
        
        if ((listingRent <= max) && (listingRent >= min)) {
             return 1
        }
        return 0
    }
    
    func checkBedrooms(listing : Listing) -> Int{
        if(self.filters[2] == "Any") {
             return 1
        }
        
        if (Int(listing.numberOfRooms) == nil) {
            return 0
        }
        
        let listingBedroom : Int = Int(listing.numberOfRooms)!
        let filterBedroom : Int = Int(self.filters[2])!
        
        if(listingBedroom == filterBedroom) {
             return 1
        }
        return 0
    }
    
    func checkPropType(listing : Listing) -> Int{
        if(self.filters[4] == "Any") {
             return 1
        }
        let listingType = listing.propertyType
        let filterType = self.filters[4]

        if (filterType == "Other") {
            if ((listingType != "House") && (listingType != "Apt.") && (listingType != "Room")) {
                 return 1
            }
            else {
                return 0
            }
        }
        else {
            if (listingType == filterType) {
                 return 1
            }
            return 0
        }
    }
    
    func checkDistance(listing : Listing) -> Int{
        if(self.filters[3] == "30.0") {
             return 1
        }
        
        if (Float(listing.milesToGU) == nil) {
            return 0
        }
        
        let listingDistance : Float = Float(listing.milesToGU)!
        let filterDistance : Float = Float(self.filters[3])!
        
        if (listingDistance <= filterDistance) {
             return 1
        }
        return 0
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
        
        cell.favoriteButton.setImage(UIImage(named: "emptyStar"), for: UIControlState.normal)
        cell.favoriteButton.setImage(UIImage(named: "filledStar"), for: UIControlState.selected)
        cell.favoriteButton.isSelected = false
        
        let listing = listings[indexPath.row]
        
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
