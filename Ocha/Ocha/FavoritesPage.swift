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

class FavoritesPage: UIViewController {
    
    let getFavorites = "http://147.222.165.203/MyWebService/api/DisplayFavorites.php"
    var favoriteListings = [FavoriteListings]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        // Do any additional setup after loading the view, typically from a nib.
        
        let viewTitle = UILabel()
        viewTitle.text = "Favorites"
        viewTitle.font = UIFont(name: viewTitle.font.fontName, size: 20)
        viewTitle.textColor = UIColor.white
        viewTitle.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (10/100), width: view.frame.width * (80/100), height: 30)
        viewTitle.textAlignment = .center
        view.addSubview(viewTitle)
        
        let toHomePageButton = UIButton()
        toHomePageButton.frame = CGRect(x: (view.frame.width) * (10/100), y: (view.frame.height) * (5/100), width: view.frame.width * (25/100) , height: 20)
        toHomePageButton.setTitle("Logout", for: UIControlState.normal)
        toHomePageButton.titleLabel?.font = UIFont(name: viewTitle.font.fontName, size: 20)
        toHomePageButton.titleLabel?.textColor = UIColor.white
        toHomePageButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        toHomePageButton.layer.cornerRadius = 4
        toHomePageButton.addTarget(self, action: #selector(FavoritesPage.logout(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(toHomePageButton)
        loadListingViews()

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
                        let milesValue = favorites[i] as? NSDictionary
                        let milesToGu = milesValue?["miles_to_gu"] as! String
                        let rentValue = favorites[i] as? NSDictionary
                        let rentPerMonth = rentValue?["rent_per_month"] as! String
                        let roomsValue = favorites[i] as? NSDictionary
                        let roomNumber = roomsValue?["number_of_rooms"] as! String
                        let propertyTypeValue = favorites[i] as? NSDictionary
                        let propertyType = propertyTypeValue?["property_type"] as! String
                        let availabilityValue = favorites[i] as? NSDictionary
                        let available = availabilityValue?["availability"] as! String
                        let favoriteIdValue = favorites[i] as? NSDictionary
                        let favoriteID = favoriteIdValue?["favorite_id"] as! Int
                        let userIdValue = favorites[i] as? NSDictionary
                        let userID = userIdValue?["user_id"] as! String
                        

                        print("LOOKHERE")
                        print(propertyID)
                        print(landlordID)
                        print(address)
                        print(milesToGu)
                        print(rentPerMonth)
                        print(roomNumber)
                        print(propertyType)
                        print(available)
                        print(favoriteID)
                        print(userID)
                        
                        if userID == uid {
                            let favoriteListing = FavoriteListings(propertyID: propertyID, landlordID: landlordID, address: address, milesToGU: milesToGu, numberOfRooms: roomNumber, monthRent: rentPerMonth, houseImage: nil, propertyType: propertyType, available: available, favoriteID: favoriteID, userID: userID)
                            self.favoriteListings.append(favoriteListing)
                            print(favoriteListing)
                        }
                        
                        // Update our table
                       // DispatchQueue.main.async(execute: {
                       //     self.propertiesList.reloadData()
                       // })
                    }
                })
            }
            catch {
                print(error)
            }
        }
        getTask.resume()
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
