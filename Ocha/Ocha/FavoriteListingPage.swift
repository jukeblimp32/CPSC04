//
//  ListingPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class FavoriteListingPage: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let createFavorites = "http://147.222.165.203/MyWebService/api/CreateFavorite.php"
    let removeFavorites = "http://147.222.165.203/MyWebService/api/RemoveFavorites.php"
    
    
    var imageUrl = ""
    var imageUrl2 = ""
    var imageUrl3 = ""
    var imageUrl4 = ""
    var imageUrl5 = ""
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
    
    @IBOutlet var propertyImage: UIImageView!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var rentLabel: UILabel!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var petsLabel: UILabel!
    @IBOutlet var leaseLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var bedroomLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var dateAvailableLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var pictureScrollView: UIScrollView!
    @IBOutlet weak var toHomePageButton: UIButton!
    
    override func viewDidLoad() {
        addressLabel.text = address
        typeLabel.text = "Property Type: " + propertyType
        distanceLabel.text = "Distance from Gonzaga: " + distance + " mile(s)"
        phoneLabel.text = "Phone Number: " + phoneNumber
        petsLabel.text = "Pets allowed: " + pets
        leaseLabel.text = "Lease Terms: " + leaseLength
        descriptionField.text = propDescription
        dateAvailableLabel.text = "Date Available: " + dateAvailable + "          Availability: " + availability
        bedroomLabel.text = "Bedrooms: " + rooms + "          Bathrooms: " + bathroomNumber
        rentLabel.text = "Rent: " + rent + "          Deposit: " + deposit
        emailLabel.text = "Email: " + email
        addressLabel.adjustsFontSizeToFitWidth = true
        emailLabel.adjustsFontSizeToFitWidth = true
        typeLabel.adjustsFontSizeToFitWidth = true
        dateAvailableLabel.adjustsFontSizeToFitWidth = true
        bedroomLabel.adjustsFontSizeToFitWidth = true
        rentLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.adjustsFontSizeToFitWidth = true
        phoneLabel.adjustsFontSizeToFitWidth = true
        petsLabel.adjustsFontSizeToFitWidth = true
        leaseLabel.adjustsFontSizeToFitWidth = true
        loadPictures()
        initializeLabels()
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        favoriteButton.isSelected = true
        favoriteButton.setImage(UIImage(named: "emptyStar"), for: UIControlState.normal)
        favoriteButton.setImage(UIImage(named: "filledStar"), for: UIControlState.selected)
        super.viewDidLoad()
        
    }
    
    func initializeLabels(){
        let screenScale = view.frame.height / 568.0
        addressLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        addressLabel.sizeToFit()
        
        distanceLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        distanceLabel.sizeToFit()
        
        phoneLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        phoneLabel.sizeToFit()
        
        petsLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        petsLabel.sizeToFit()
        
        leaseLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        leaseLabel.sizeToFit()
        
        descriptionField.font = UIFont.systemFont(ofSize: 18 * screenScale)
        descriptionField.sizeToFit()
        
        dateAvailableLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        dateAvailableLabel.sizeToFit()
        
        bedroomLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        bedroomLabel.sizeToFit()
        
        rentLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        rentLabel.sizeToFit()
        
        typeLabel.font = UIFont.systemFont(ofSize: 18 * screenScale)
        typeLabel.sizeToFit()
        
        // Make attributed text to create link
        let mutableText = NSMutableAttributedString(string: "Email: " + email, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 18 * screenScale)])
        // Underline the email
        mutableText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 7, length: mutableText.length - 7))
        // Color the email
        mutableText.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 30.0/255, green: 52.0/255, blue: 75.0/255, alpha: 1), range:  NSRange(location: 7, length: mutableText.length - 7))
        // Add interaction
        emailLabel.isUserInteractionEnabled = true
        emailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FavoriteListingPage.openUpEmail)))
        emailLabel.attributedText = mutableText
        
    }
    
    func openUpEmail(sender: UITapGestureRecognizer){
        let emailsize = (emailLabel.attributedText?.length)! - 7
        // Set the range of the email. Subtract one to avoid index problems
        let emailRange = NSRange(location: 7, length: emailsize - 1)
        let tapLocation = sender.location(in: emailLabel)
        let tapindex = emailLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        // Only open email if the email address was selected
        if tapindex >= emailRange.location && tapindex < (emailRange.location + emailRange.length){
            // Can only send email if the device has mail set up
            if(MFMailComposeViewController.canSendMail())
            {
                // Address the email
                let editComposerVC = MFMailComposeViewController()
                editComposerVC.mailComposeDelegate = self
                editComposerVC.setToRecipients([email])
                editComposerVC.setSubject("Regarding Your Property at \(address)")
                self.present(editComposerVC, animated: true, completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "Email Not Setup", message:"Please set up your email in order to contact landlords.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default))
                self.present(alert, animated: true){}
            }
            
        }
    }
    
    
    @IBAction func starPressed(_ sender: UIButton) {
        if (sender.isSelected){
            sender.isSelected = false
            removeFavorite()
        }
        else
        {
            sender.isSelected = true
            createFavorite()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == 2{
            return view.frame.width * (65/100)
        }
        if section == 0 && row == 3{
            return view.frame.height * (7/100)
        }
        if section == 0 && row == 4{
            return view.frame.height * (7/100)
        }
        if section == 1{
            return view.frame.height * (7/100)
        }
        if section == 2 && row == 0 {
            return view.frame.height * (30/100)
        }
        if section == 3 {
            return view.frame.height * (7/100)
        }
        if section == 4{
            return view.frame.height * (7/100)
        }
        return UITableViewAutomaticDimension
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "favoriteToReview",
            let destination = segue.destination as? FavoritePropertyReviews
            
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
            
        }
    }
    
    
    
    func loadPictures() {
        let myImages = [self.imageUrl, self.imageUrl2, self.imageUrl3, self.imageUrl4, self.imageUrl5]
        
        let offset = view.frame.width * (20/100)
        let size = view.frame.width * (60/100)
        let imageWidth : CGFloat = size
        let imageHeight : CGFloat = size
        var xPosition : CGFloat = offset
        var scrollViewSize : CGFloat = 0
        
        for image in myImages {
            let myImageView : UIImageView = UIImageView()
            myImageView.contentMode = .scaleAspectFit
            myImageView.clipsToBounds = true
            myImageView.loadCachedImages(url: image)
            
            myImageView.frame.size.width = imageWidth
            myImageView.frame.size.height = imageHeight
            myImageView.frame.origin.x = xPosition
            myImageView.frame.origin.y = 0
            
            pictureScrollView.addSubview(myImageView)
            xPosition += imageWidth + offset
            scrollViewSize += imageWidth + offset
            
        }
        scrollViewSize += offset
        
        pictureScrollView.contentSize = CGSize(width: scrollViewSize, height: imageHeight)
    }
    
    func createFavorite(){
        //created NSURL
        let saveRequestURL = NSURL(string: createFavorites)
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields
        
        //let landlordID = self.firstName
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        
        //post parameter
        //concatenating keys and values from text field
        let propID = propertyID
        let userID = uid
        let postParameters="property_id="+String(propID)+"&user_id="+userID!;
        
        
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
    
    func removeFavorite(){
        //created NSURL
        let saveRequestURL = NSURL(string: removeFavorites)
        
        //creating NSMutableURLRequest
        let saveRequest = NSMutableURLRequest(url:saveRequestURL! as URL)
        
        //setting method to POST
        saveRequest.httpMethod = "POST"
        
        //getting values from text fields
        
        //let landlordID = self.firstName
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        //post parameter
        //concatenating keys and values from text field
        let propID = propertyID
        let userID = uid
        let postParameters="property_id="+String(propID)+"&user_id="+userID!;
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // May need alert to stop from cancelling
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}
