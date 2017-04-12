//
//  UnseenReviews.swift
//  Ocha
//
//  Created by Talkov, Leah C on 4/12/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit

class UnseenReviews: UITableViewController {
    let getReviews = "http://147.222.165.203/MyWebService/api/DisplayReviews.php"
    
    var reviews = [Review]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        reviews.removeAll()
        loadReviews()
        refreshControl?.addTarget(self, action: #selector(UnseenReviews.handleRefresh(_:)), for: .valueChanged)
        self.tableView.register(UnseenReviewTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.addSubview(refreshControl!)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "UnseenReviewTableViewCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as! UnseenReviewTableViewCell
        
        let review = reviews[indexPath.row]
        
        cell.propertyID = review.propertyID
        cell.reviewNum = review.reviewNum
        cell.responseScore.text = review.landlordResponse
        cell.locationScore.text = review.location
        cell.valueScore.text = review.priceValue
        cell.spaceScore.text = review.space
        cell.qualityScore.text = review.quality
        cell.emailLabel.text = "User: " + review.email
        cell.dateLabel.text = review.date
        return cell
    }
    
    func handleRefresh(_ sender : UIRefreshControl) {
        reviews.removeAll()
        loadReviews()
        refreshControl?.endRefreshing()
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
                        let emailValue = propReviews[i] as? NSDictionary
                        let email = emailValue?["email"] as! String
                        let dateValue = propReviews[i] as? NSDictionary
                        let date = dateValue?["date"] as! String
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

                        //IF STATUS != SEEN
                        //if (self.propertyID == propID) {
                            let review = Review(propertyID: propID, reviewNum: reviewID, email: email, date: date, landlordResponse : category1, location : category2, priceValue : category3, space : category4, quality : category5)

                            self.reviews.append(review)
                       // }
                    }

                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                    
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

