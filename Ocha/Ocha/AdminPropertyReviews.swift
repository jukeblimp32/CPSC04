//
//  AdminPropertyReviews.swift
//  Ocha
//
//  Created by Talkov, Leah C on 3/24/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit

class AdminPropertyReviews: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let getReviews = "http://147.222.165.203/MyWebService/api/DisplayReviews.php"
    let deleteReviews = "http://147.222.165.203/MyWebService/api/deleteReview.php"
    
    @IBOutlet var propertyReviews: UITableView!
    @IBOutlet var avgResponseScore: UILabel!
    @IBOutlet var avgLocationScore: UILabel!
    @IBOutlet var avgValueScore: UILabel!
    @IBOutlet var avgSpaceScore: UILabel!
    @IBOutlet var avgQualityScore: UILabel!
    
    @IBOutlet var responseLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var spaceLabel: UILabel!
    @IBOutlet var qualityLabel: UILabel!
    
    @IBOutlet var qualityBar: UIProgressView!
    @IBOutlet var spaceBar: UIProgressView!
    @IBOutlet var priceBar: UIProgressView!
    @IBOutlet var locationBar: UIProgressView!
    @IBOutlet var responseBar: UIProgressView!
    @IBOutlet weak var reviewMsg: UILabel!
    
    var reviews = [Review]()
    
    var imageUrl = ""
    var imageUrl2 = ""
    var imageUrl3 = ""
    var imageUrl4 = ""
    var imageUrl5 = ""
    var landlordID : String = ""
    var propertyType : String = ""
    var address : String = ""
    var distance : String = ""
    var rooms : String = ""
    var rent : String = ""
    var phoneNumber : String = ""
    var dateAvailable : String = ""
    var deposit : String = ""
    var bathroomNumber : String = ""
    var leaseLength : String = ""
    var pets : String = ""
    var availability: String = ""
    var propDescription : String = ""
    var email : String = ""
    var propertyID : Int = 0
    var image : UIImage = UIImage(named: "default")!
    var favoritePropIDs = [Int]()
    
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviews.removeAll()
        loadReviews()
        print(reviews.count)
        self.propertyReviews.register(AdminReviewTableViewCell.self, forCellReuseIdentifier: "cell")
        propertyReviews.delegate = self
        propertyReviews.dataSource = self
        propertyReviews.reloadData()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(AdminPropertyReviews.handleRefresh(_:)), for: .valueChanged)
        propertyReviews.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
        responseLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "toAdminListing",
            let destination = segue.destination as? AdminListingPage
            
        {
            destination.address = address
            destination.rent = rent
            destination.rooms = rooms
            destination.distance = distance
            destination.imageUrl = imageUrl
            destination.imageUrl2 = imageUrl2
            destination.imageUrl3 = imageUrl3
            destination.imageUrl4 = imageUrl4
            destination.imageUrl5 = imageUrl5
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
            destination.propertyType = propertyType
            destination.landlordID = landlordID
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AdminReviewTableViewCell"
        let cell = self.propertyReviews.dequeueReusableCell(withIdentifier: cellIdentifier, for : indexPath) as! AdminReviewTableViewCell
        
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
        cell.deleteReview.tag = indexPath.row
        cell.deleteReview.addTarget(self, action: #selector(self.deleteReview(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    func handleRefresh(_ sender : UIRefreshControl) {
        loadReviews()
        refreshControl.endRefreshing()
    }
    
    func deleteReview(_ sender: UIButton)
    {
        let cell = reviews[sender.tag]
        let reviewID = String(cell.reviewNum)
        // Make pop up
        let alertVC = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete this property review?", preferredStyle: .alert)

        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }

        let alertActionYes = UIAlertAction(title: "Yes", style: .default){
            (_) in
            let saveRequestURL = NSURL(string: self.deleteReviews)
            
            //creating NSMutableURLRequest
            let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
            
            //setting method to POST
            saveRequest.httpMethod = "POST"
            
            //getting values from text fields
            
            //let landlordID = self.firstName
            let postParameters="review_id="+reviewID;
            
            //adding parameters to request body
            saveRequest.httpBody=postParameters.data(using: String.Encoding.utf8)
            //task to send to post request
            let saveTask=URLSession.shared.dataTask(with: saveRequest as URLRequest){
                data,response, error in
                if error != nil{
                    print("error is \(error)")
                    return;
                }
                do{
                    //converting response to NSDictioanry
                    
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    if let parseJSON = myJSON{
                        var msg:String!
                        msg = parseJSON["message"]as! String?
                        print(msg)
                    }
                }catch{
                    print(error)
                }
            }
            saveTask.resume()
            print("Deleted Review successfully")
            
        }
        alertVC.addAction(alertActionCancel)
        alertVC.addAction(alertActionYes)
        self.present(alertVC, animated: true, completion: nil)
    }

    func loadReviews(){
        
        var reponseTotal = 0
        var locationTotal = 0
        var valueTotal = 0
        var spaceTotal = 0
        var qualityTotal = 0
        var tempReviews : [Review] = []

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
                        let addressValue = propReviews[i] as? NSDictionary
                        let address = addressValue?["address"] as! String
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
                        
                        if (self.propertyID == propID) {
                            let review = Review(propertyID: propID, reviewNum: reviewID, email: email, date: date, landlordResponse : category1, location : category2, priceValue : category3, space : category4, quality : category5, address : address)
                            
                            reponseTotal += Int(category1)!
                            locationTotal += Int(category2)!
                            valueTotal += Int(category3)!
                            spaceTotal += Int(category4)!
                            qualityTotal += Int(category5)!
                            
                            tempReviews.append(review)
                        }
                    }
                    self.reviews = tempReviews
                    let reviewCount = self.reviews.count
                    
                    if(reviewCount != 0) {
                        self.responseBar.progress = Float((round(10 * (Double(reponseTotal) / Double(reviewCount))) / 10)/5)
                        self.avgResponseScore.text = String(round(10 * (Double(reponseTotal) / Double(reviewCount))) / 10)
                        self.locationBar.progress = Float((round(10 * (Double(locationTotal) / Double(reviewCount))) / 10)/5)
                        self.avgLocationScore.text = String(round(10 * (Double(locationTotal) / Double(reviewCount))) / 10)
                        self.priceBar.progress = Float((round(10 * (Double(valueTotal) / Double(reviewCount))) / 10)/5)
                        self.avgValueScore.text = String(round(10 * (Double(valueTotal) / Double(reviewCount))) / 10)
                        self.spaceBar.progress = Float((round(10 * (Double(spaceTotal) / Double(reviewCount))) / 10)/5)
                        self.avgSpaceScore.text = String(round(10 * (Double(spaceTotal) / Double(reviewCount))) / 10)
                        self.qualityBar.progress = Float((round(10 * (Double(qualityTotal) / Double(reviewCount))) / 10)/5)
                        self.avgQualityScore.text = String(round(10 * (Double(qualityTotal) / Double(reviewCount))) / 10)
                        self.propertyReviews.isHidden = false
                        self.reviewMsg.isHidden = true
                        
                    }
                        
                    else {
                        self.responseBar.progress = 0
                        self.avgResponseScore.text = "N/A"
                        self.locationBar.progress = 0
                        self.avgLocationScore.text = "N/A"
                        self.priceBar.progress = 0
                        self.avgValueScore.text = "N/A"
                        self.spaceBar.progress = 0
                        self.avgSpaceScore.text = "N/A"
                        self.qualityBar.progress = 0
                        self.avgQualityScore.text = "N/A"
                        self.propertyReviews.isHidden = true
                        self.reviewMsg.isHidden = false
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.propertyReviews.reloadData()
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
