//
//  UnseenReviewTableViewCell.swift
//  Ocha
//
//  Created by Talkov, Leah C on 4/12/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit
import Firebase

class UnseenReviewTableViewCell: UITableViewCell {
    let updateReviews = "http://147.222.165.203/MyWebService/api/reviewUpdate.php"
    let deleteReviews = "http://147.222.165.203/MyWebService/api/deleteReview.php"
    var propertyID : Int = 0
    var reviewNum: Int = 0
    
    @IBOutlet weak var seenButton: UIButton!
    
    @IBOutlet var deleteReview: UIButton!

    @IBOutlet var landlordLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var responseScore: UILabel!
    @IBOutlet var locationScore: UILabel!
    @IBOutlet var valueScore: UILabel!
    @IBOutlet var spaceScore: UILabel!
    @IBOutlet var qualityScore: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        emailLabel.adjustsFontSizeToFitWidth = true
        addressLabel.adjustsFontSizeToFitWidth = true
        landlordLabel.adjustsFontSizeToFitWidth = true
    }
    
    
    @IBAction func deleteReview(_ sender: Any) {
        
        self.deleteReview.setTitle("Deleted", for: UIControlState.normal)
        let saveRequestURL = NSURL(string: self.deleteReviews)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields
        
        //let landlordID = self.firstName
        let postParameters="review_id="+String(self.reviewNum);
        
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
    
    @IBAction func unseenButton(_ sender: Any) {
        self.seenButton.setTitle("Seen", for: UIControlState.normal)
        //created NSURL
        let saveRequestURL = NSURL(string: updateReviews)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        let currentReview = String(reviewNum)
        //post parameter
        //concatenating keys and values from text field
        let postParameters="status=SEEN"+"&review_id="+currentReview;
        
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
    }
    
}
