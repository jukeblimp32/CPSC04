//
//  StudentPropertyReviews.swift
//  Ocha
//
//  Created by Talkov, Leah C on 3/22/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit

class StudentPropertyReviews: UITableViewController {
    let getReviews = "http://147.222.165.203/MyWebService/api/DisplayReviews.php"
    
    @IBOutlet var propertyReviews: UITableView!
    
    var reviews = [Review]()
    
    var imageUrl = ""
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
    var email : String = ""
    var propertyID : Int = 0
    var image : UIImage = UIImage(named: "default")!
    var favoritePropIDs = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviews.removeAll()
        loadReviews()
        self.propertyReviews.register(ReviewTableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "exitReviews",
            let destination = segue.destination as? ListingPage

        {
            destination.address = address
            destination.rent = rent
            destination.rooms = rooms
            destination.distance = distance
            destination.imageUrl = imageUrl
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
            
        }
        
        if segue.identifier == "createReview",
            let destination = segue.destination as? CreateReview
            
        {
            destination.address = address
            destination.rent = rent
            destination.rooms = rooms
            destination.distance = distance
            destination.imageUrl = imageUrl
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
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ReviewTableViewCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as! ReviewTableViewCell
        
        let review = reviews[indexPath.row]
        
        cell.propertyID = review.propertyID
        cell.reviewNum = review.reviewNum
        cell.responseScore.text = review.landlordResponse
        cell.locationScore.text = review.location
        cell.valueScore.text = review.priceValue
        cell.spaceScore.text = review.space
        cell.qualityScore.text = review.quality

        
        return cell
    }
    
    
    func loadReviews(){
        //create NSURL
        let getRequestURL = NSURL(string: getReviews)
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
                let propReviews: NSArray = propertyJSON["reviews"] as! NSArray
                
                //looping through all the objects in the array
                DispatchQueue.main.async(execute: {
                    for i in 0 ..< propReviews.count{
                        //Getting data from each listing and saving to vars
                        let reviewIdValue = propReviews[i] as? NSDictionary
                        let reviewID = reviewIdValue?["review_id"] as! Int
                        let propIdValue = propReviews[i] as? NSDictionary
                        let propID = propIdValue?["property_id"] as! Int
                        let cat1Value = propReviews[i] as? NSDictionary
                        let category1 = cat1Value?["category_1"] as! String
                        let cat2Value = propReviews[i] as? NSDictionary
                        let category2 = cat2Value?["category_2"] as! String
                        let cat3Value = propReviews[i] as? NSDictionary
                        let category3 = cat3Value?["category_3"] as! String
                        let cat4Value = propReviews[i] as? NSDictionary
                        let category4 = cat4Value?["category_4"] as! String
                        let cat5Value = propReviews[i] as? NSDictionary
                        let category5 = cat5Value?["category_5"] as! String
                      
                        
                        if (self.propertyID == propID) {
                            let review = Review(propertyID: propID, reviewNum: reviewID, landlordResponse : category1, location : category2, priceValue : category3, space : category4, quality : category5)
                            
                            self.reviews.append(review)
                        }
                    }
                    
                })
            }
            catch {
                print(error)
            }
        }
        getTask.resume()
    }

    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

