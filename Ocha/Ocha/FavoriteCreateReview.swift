//
//  FavoriteCreateReview.swift
//  Ocha
//
//  Created by Talkov, Leah C on 3/29/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit

class FavoriteCreateReview: UIViewController {
    
    let URL_SAVE_REVIEW = "http://147.222.165.203/MyWebService/api/createReview.php"
    
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
    
    @IBOutlet var backToReviews: UIButton!
    @IBOutlet var responseScore: UILabel!
    @IBOutlet var locationScore: UILabel!
    @IBOutlet var valueScore: UILabel!
    @IBOutlet var spaceScore: UILabel!
    @IBOutlet var qualityScore: UILabel!
    
    @IBOutlet var priceValueSlider: UISlider!
    @IBOutlet var responseSlider: UISlider!
    @IBOutlet var locationSlider: UISlider!
    @IBOutlet var spaceSlider: UISlider!
    @IBOutlet var qualitySlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(email)
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "backToFavoriteReview",
            let destination = segue.destination as? FavoritePropertyReviews
            
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
    
    
    @IBAction func responseSliderChanged(_ sender: Any) {
        self.responseScore.text = String(Int(self.responseSlider.value))
    }
    
    
    @IBAction func locationSliderChanged(_ sender: Any) {
        self.locationScore.text = String(Int(self.locationSlider.value))
    }
    
    
    @IBAction func priceValueSliderChanged(_ sender: Any) {
        self.valueScore.text = String(Int(self.priceValueSlider.value))
    }
    
    @IBAction func spaceSliderChanged(_ sender: Any) {
        self.spaceScore.text = String(Int(self.spaceSlider.value))
    }
    
    @IBAction func qualitySliderChanged(_ sender: Any) {
        self.qualityScore.text = String(Int(self.qualitySlider.value))
    }
    
    
    @IBAction func submitReview(_ sender: Any) {
        // Create alert
        let alertConfirm = UIAlertController(title: "Confirmation", message: "Are you sure you would like to submit your review?", preferredStyle: .alert)
        
        // Do nothing if we cancel
        let alertCancel = UIAlertAction(title: "Cancel", style: .default) {
            (_) in
            return
        }
        // If yes, delete the listing from the database
        let alertYes = UIAlertAction(title: "Yes", style: .default){
            (_) in
            self.registerReview()
        }
        alertConfirm.addAction(alertCancel)
        alertConfirm.addAction(alertYes)
        self.present(alertConfirm, animated: true, completion: nil)
        
    }
    
    func registerReview(){
        //created NSURL
        let saveRequestURL = NSURL(string: URL_SAVE_REVIEW)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields
        
        //let propId = propertyID
        
        let propId = String(propertyID)
        let landlordResponse = responseScore.text
        let location = locationScore.text
        let priceValue = valueScore.text
        let spacePerson = spaceScore.text
        let overallQuality = qualityScore.text
        
        let postParameters = "property_id="+propId+"&category_1="+landlordResponse!+"&category_2="+location!+"&category_3="+priceValue!+"&category_4="+spacePerson!+"&category_5="+overallQuality!;
        
        
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
                let alert = UIAlertController(title: "Review Added!", message:"Review added", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                self.present(alert, animated: true){}
                
                //Here is the problem child
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
        self.backToReviews.sendActions(for: .touchUpInside)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

