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
    var listings = [Listing]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.propertiesList.register(ListingTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        
        loadListingViews()
    }
    
    func loadListingViews() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as! ListingTableViewCell
        
        let listing = listings[indexPath.row]
        
        cell.propertyAddress.text = listing.address
        cell.propertyDistance.text = Str(listing.milesToGU)
        cell.propertyRent.text = listing.monthRent
        cell.propertyRooms.text = listing.numberOfRooms
        cell.propertyImage.image = listing.houseImage
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        
    }
    
}
