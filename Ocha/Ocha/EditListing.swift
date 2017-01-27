//
//  EditListing.swift
//  Ocha
//
//  Created by Talkov, Leah C on 1/23/17.
//  Copyright © 2017 CPSC04. All rights reserved.
//

import UIKit

class EditListing: UITableViewController {
    
    var address : String = ""
    
    var rent : String = ""
    
    var bedroomNum : String = ""
    
    var distance : String = ""
    
    var image : UIImage = UIImage(named: "default")!
    
    var propertyID : Int = 0
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var rentTextField: UITextField!
    
    @IBOutlet weak var bedroomTextField: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.text = address
        rentTextField.text = rent
        bedroomTextField.text = bedroomNum
        stepper.value = Double(bedroomNum)!
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 10
    }
    
    @IBAction func changeBedroomNumber(_ sender: UIStepper) {
        bedroomTextField.text = Int(sender.value).description
    }
    
    @IBAction func reverseChanges(_ sender: Any) {
        addressTextField.text = address
        rentTextField.text = rent
        bedroomTextField.text = bedroomNum
        stepper.value = Double(bedroomNum)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue from any table cell to listingPage is clicked
        if segue.identifier == "backToListing",
            //Sets the page to be loaded as ListingPage
            let destination = segue.destination as? ListingPage
            //Gets the selected cell index
        {
            //Setting the variables in the listing class to the cell info
            destination.address.text = address
            destination.rent.text = rent
            destination.rooms.text = bedroomNum
            destination.distance.text = distance
            destination.image.image = image
            destination.propertyID = propertyID
        }
    }
    
    
    //OVER HERE ELMA :) :) :)
    @IBAction func saveEdits(_ sender: Any) {
        //address info
        let editAddress = addressTextField.text
        
        //rent info
        let editRent = rentTextField.text
        
        //bedroom info
        let editBedroom = bedroomTextField.text
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
}
