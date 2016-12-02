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
    var listings = [Listing]()
    var valueTopass : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.propertiesList.register(ListingTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        // Initialize our table
        propertiesList.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (10/100), width: view.frame.width * (80/100), height: (view.frame.height) * (90/100))
        propertiesList.delegate = self
        propertiesList.dataSource = self
        propertiesList.reloadData()

        //}
        
        let viewTitle = UILabel()
        
        let toHomePageButton = UIButton()
        toHomePageButton.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (5/100), width: view.frame.width * (25/100) , height: 20)
        toHomePageButton.setTitle("Logout", for: UIControlState.normal)
        toHomePageButton.titleLabel?.adjustsFontSizeToFitWidth = true
        toHomePageButton.titleLabel?.textColor = UIColor.white
        toHomePageButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        toHomePageButton.layer.cornerRadius = 4
        toHomePageButton.addTarget(self, action: #selector(StudentHomePage.logout(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(toHomePageButton)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listings.removeAll()
        loadListingViews()
        propertiesList.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "showDetail",
            let destination = segue.destination as? ListingPage,
            let blogIndex = propertiesList.indexPathForSelectedRow?.row
        {
            destination.address.text = listings[blogIndex].address
            destination.rent.text = listings[blogIndex].monthRent
            destination.distance.text = listings[blogIndex].milesToGU
            destination.rooms.text = listings[blogIndex].numberOfRooms
            destination.image.image = listings[blogIndex].houseImage
        }
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
                
                //looping through all the json objects in the array properties
                DispatchQueue.main.async(execute: {
                    for i in 0 ..< properties.count{
                        //getting the data at each index
                        let propIdValue = properties[i] as? NSDictionary
                        let propertyID = propIdValue?["property_id"] as! Int
                        let addressValue = properties[i] as? NSDictionary
                        let address = addressValue?["address"] as! String
                        let milesValue = properties[i] as? NSDictionary
                        let milesToGu = milesValue?["miles_to_gu"] as! String
                        let rentValue = properties[i] as? NSDictionary
                        let rentPerMonth = rentValue?["rent_per_month"] as! String
                        let roomsValue = properties[i] as? NSDictionary
                        let roomNumber = roomsValue?["number_of_rooms"] as! String
                    
                        let listing = Listing(propertyID: propertyID, address: address, milesToGU: milesToGu, numberOfRooms: roomNumber, monthRent: rentPerMonth, houseImage: nil)
                        self.listings.append(listing)
                        
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
        /*
        let photo1 = UIImage(named: "Image-1")
        let listing1 = Listing(propertyID: "35sf", address: "533 Strange Street", milesToGU: 0.9, numberOfRooms: 4, monthRent: 350, houseImage: photo1)
        let listing2 = Listing(propertyID: "35sf", address: "533 Strange Street", milesToGU: 0.9, numberOfRooms: 4, monthRent: 350, houseImage: nil)
        let photo3 = UIImage(named: "Image-2")
        let listing3 = Listing(propertyID: "35sf", address: "533 Strange Street", milesToGU: 0.9, numberOfRooms: 4, monthRent: 350, houseImage: photo3)
        let photo4 = UIImage(named: "Image-3")
        let listing4 = Listing(propertyID: "35sf", address: "533 Strange Street", milesToGU: 0.9, numberOfRooms: 4, monthRent: 350, houseImage: photo4)
        let photo5 = UIImage(named: "Image-4")
        let listing5 = Listing(propertyID: "35sf", address: "533 Strange Street", milesToGU: 0.9, numberOfRooms: 4, monthRent: 350, houseImage: photo5)
        let photo6 = UIImage(named: "Image-5")
        let listing6 = Listing(propertyID: "35sf", address: "533 Strange Street", milesToGU: 0.9, numberOfRooms: 4, monthRent: 350, houseImage: photo6)
        
        listings += [listing1, listing2, listing3, listing4, listing5, listing6]
 */
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
        
        cell.propertyAddress.text = listing.address
        cell.propertyDistance.text = String(listing.milesToGU)
        cell.propertyRent.text = String(listing.monthRent)
        cell.propertyRooms.text = String(listing.numberOfRooms)
        cell.propertyImage.image = listing.houseImage
        
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
 
    
    
}
