//
//  ListingPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class ListingPage: UIViewController {
    
    
    var image = UIImageView()
    
    var address = UILabel()
    
    var distance = UILabel()
    
    var rooms = UILabel()
    
    var rent = UILabel()
    
    var propertyID : Int = 0
    
    @IBOutlet weak var toHomePageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // addressText = address.text!
        //rentText = rent.text!
        address.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (15/100), width: view.frame.width * (90/100) , height: 30)
        address.font = UIFont(name: address.font.fontName, size: 20)
        address.textColor = UIColor.white
        view.addSubview(address)
        
        image.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (25/100), width: view.frame.width * (50/100) , height: (view.frame.height * 25/100))
        view.addSubview(image)
        
        distance.frame = CGRect(x: (view.frame.width) * (80/100), y: (view.frame.height) * (75/100), width: view.frame.width * (45/100) , height: 30)
        distance.font = UIFont(name: address.font.fontName, size: 20)
        distance.textColor = UIColor.white
        view.addSubview(distance)
        
        rooms.frame = CGRect(x: (view.frame.width) * (80/100), y: (view.frame.height) * (65/100), width: view.frame.width * (45/100) , height: 30)
        rooms.font = UIFont(name: address.font.fontName, size: 20)
        rooms.textColor = UIColor.white
        view.addSubview(rooms)
        
        rent.frame = CGRect(x: (view.frame.width) * (80/100), y: (view.frame.height) * (55/100), width: view.frame.width * (45/100) , height: 30)
        rent.font = UIFont(name: address.font.fontName, size: 20)
        rent.textColor = UIColor.white
        view.addSubview(rent)
        
        let distanceLabel = UILabel()
        distanceLabel.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (75/100), width: view.frame.width * (60/100) , height: 30)
        distanceLabel.font = UIFont(name: address.font.fontName, size: 20)
        distanceLabel.text = "Distance:"
        distanceLabel.textColor = UIColor.white
        view.addSubview(distanceLabel)
        
        
        let roomLabel = UILabel()
        roomLabel.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (65/100), width: view.frame.width * (60/100) , height: 30)
        roomLabel.font = UIFont(name: address.font.fontName, size: 20)
        roomLabel.text = "Number of Rooms:"
        roomLabel.textColor = UIColor.white
        view.addSubview(roomLabel)
        
        let rentLabel = UILabel()
        rentLabel.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (55/100), width: view.frame.width * (60/100) , height: 30)
        rentLabel.text = "Rent per Month:"
        rentLabel.font = UIFont(name: address.font.fontName, size: 20)
        rentLabel.textColor = UIColor.white
        view.addSubview(rentLabel)
        
        toHomePageButton.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (5/100), width: view.frame.width / 5 , height: 20)
        toHomePageButton.setTitle("Back", for: UIControlState.normal)
        toHomePageButton.titleLabel?.font = UIFont(name: address.font.fontName, size: 20)
        toHomePageButton.titleLabel?.textColor = UIColor.white
        toHomePageButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        toHomePageButton.layer.cornerRadius = 4
        view.addSubview(toHomePageButton)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "EditListing",
            //Sets the page to be loaded as ListingPage
            let destination = segue.destination as? EditListing
            //Gets the selected cell index
            //Setting the variables in the listing class to the cell info 
        {
            destination.address = address.text!
            destination.rent = rent.text!
            destination.bedroomNum = rooms.text!
            destination.distance = distance.text!
            destination.image = image.image!
            destination.propertyID = propertyID
        }
    }
  
    


    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
