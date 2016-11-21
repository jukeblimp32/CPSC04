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
    var listings = [Listing]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.propertiesList.register(ListingTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        loadListingViews()
        
        // Initialize our table
        propertiesList.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (10/100), width: view.frame.width * (80/100), height: (view.frame.height) * (80/100))
        propertiesList.delegate = self
        propertiesList.dataSource = self
        propertiesList.reloadData()

        //}
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
                        let propertyID = propIdValue?["property_id"] as! String
                        let addressValue = properties[i] as? NSDictionary
                        let address = addressValue?["address"] as! String
                        let milesValue = properties[i] as? NSDictionary
                        let milesToGu = milesValue?["miles_to_gu"] as! Int
                        let rentValue = properties[i] as? NSDictionary
                        let rentPerMonth = rentValue?["rent_per_month"] as! Int
                        let roomsValue = properties[i] as? NSDictionary
                        let roomNumber = roomsValue?["number_of_rooms"] as! Int
                    
                        let listing = Listing(propertyID: propertyID, address: address, milesToGU: Float(milesToGu), numberOfRooms: roomNumber, monthRent: rentPerMonth, houseImage: nil)
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
    
    
    
    @IBAction func logout(_ sender: Any) {
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
    
    func tableView(_ tableView: UITableView, heightForRowAtIndex indexPath: IndexPath) -> CGFloat {
        return self.propertiesList.frame.height / 4.0
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let destinationViewController = segue.destination as! ListingPage
            
            // Get the cell that generated this segue.
            if let selectedListingCell = sender as? ListingTableViewCell {
                let indexPath = propertiesList.indexPath(for: selectedListingCell)!
                let listing = listings[indexPath.row]
                destinationViewController.image.image = listing.houseImage
                destinationViewController.address.text = listing.address
                destinationViewController.rent.text = String(listing.monthRent)
                destinationViewController.rooms.text = String(listing.numberOfRooms)
                destinationViewController.distance.text = String(listing.milesToGU)
                
                
            }
        }

    }
    

<<<<<<< HEAD
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Hey")
=======
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        /*
        let listing = listings[indexPath.row]
        if let subjectCell = tableView.cellForRow(at: indexPath as IndexPath), let destinationViewController = navigationController?.storyboard?.instantiateViewController(withIdentifier: "ListingPage") as? ListingPage{
            //This is a bonus, I will be showing at destionation controller the same text of the cell from where it comes...
            destinationViewController.address.text = listing.address
            destinationViewController.distance.text = String(listing.milesToGU)
            destinationViewController.rooms.text = String(listing.numberOfRooms)
            destinationViewController.rent.text = String(listing.monthRent)
            destinationViewController.image.image = listing.houseImage
            //Then just push the controller into the view hierarchy
            navigationController?.pushViewController(destinationViewController, animated: true)
 
        }
        */
        
        
        
        
>>>>>>> 336cbc250426b2c03a632636dbe3c9b5cdb32baf
    }
    
}
