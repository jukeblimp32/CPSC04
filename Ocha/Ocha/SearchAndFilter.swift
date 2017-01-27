//
//  SearchAndFilter.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/11/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SearchAndFilter: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var bedroomNum: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var pickerMin: UIPickerView!
    
    @IBOutlet weak var pickerMax: UIPickerView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var propTypeSelect: UISegmentedControl!
    
    @IBOutlet weak var petSelect: UISegmentedControl!
    
    
    var pickerData = ["Any", "200", "300", "400", "500", "600", "700", "800", "900", "1000", "1100", "1200",
    "1300", "1400", "1500", "1600", "1700", "1800", "1900", "2000", "2100", "2200", "2300", "2400", "2500", "2600", "2700", "2800", "2900", "3000"]
    
    let getPropertyFilters = "http://147.222.165.203/MyWebService/api/PropertyFilters.php"
    var filters = [Filters]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.backgroundColor = UIColor.init(red: 1.0/255, green: 87.0/255, blue: 155.0/255, alpha: 1)
        stepper.wraps = true
        stepper.autorepeat = true
        stepper.maximumValue = 10
        // Do any additional setup after loading the view, typically from a nib.
        pickerMin.delegate = self
        pickerMin.dataSource = self
        pickerMax.delegate = self
        pickerMax.dataSource = self
    }
    
    @IBAction func changeRoomNum(_ sender: UIStepper) {
        if Int(sender.value).description == "0" {
            self.bedroomNum.text = "Any"
        }
        else {
            self.bedroomNum.text = Int(sender.value).description
        }
    }
    

    @IBAction func sliderChanged(_ sender: UISlider) {
        self.distanceLabel.text = "Under " + String(format: "%.1f", self.slider.value) + " miles"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    @IBAction func clearFilters(_ sender: Any) {
        pickerMin.selectRow(0, inComponent: 0, animated: true)
        pickerMax.selectRow(0, inComponent: 0, animated: true)
        self.distanceLabel.text = "Under 10.0 miles"
        slider.value = 10
        stepper.value = 0
        self.bedroomNum.text = "Any"
        propTypeSelect.selectedSegmentIndex = 0
        petSelect.selectedSegmentIndex = 0
    }
    
    @IBAction func applyFilters(_ sender: Any) {
        //create NSURL
        let getRequestURL = NSURL(string: getPropertyFilters )
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
                let properties: NSArray = propertyJSON["properties"] as! NSArray
                
                //looping through all the objects in the array
               // DispatchQueue.main.async(execute: {
                    for i in 0 ..< properties.count{
                        //Getting data from each listing and saving to vars
                        let propIdValue = properties[i] as? NSDictionary
                        let propertyID = propIdValue?["property_id"] as! Int
                        let roomValue = properties[i] as? NSDictionary
                        let numberRooms = roomValue?["number_of_rooms"] as! String
                        let rentValue = properties[i] as? NSDictionary
                        let rentPerMonth = rentValue?["rent_per_month"] as! String
                        let milesValue = properties[i] as? NSDictionary
                        let milesToGu = milesValue?["miles_to_gu"] as! String
                        let propertyValue = properties[i] as? NSDictionary
                        let propertyType = propertyValue?["property_type"] as! String
                        
                        let propertyFilter = Filters(propertyID: propertyID, numberOfRooms: numberRooms, monthRent: rentPerMonth, milesToGU: milesToGu, propertyType: propertyType )
                        
                        
                        //Append this to list of listings
                        self.filters.append(propertyFilter)
                        
                        //Update the tableview in student homepage to show the listing cells
                    /*    DispatchQueue.main.async(execute: {
                            self.propertiesList.reloadData()
                        }) */
                    }
                //})
            }
            catch {
                print(error)
            }
        }
        getTask.resume()

        var minPriceFilter = pickerData[pickerMin.selectedRow(inComponent: 0)]
        var maxPriceFilter = pickerData[pickerMax.selectedRow(inComponent: 0)]
        var bedroomFilter = bedroomNum.text
        var distanceFilter = distanceLabel.text
        var propertyFilter = propTypeSelect.titleForSegment(at: propTypeSelect.selectedSegmentIndex)
        var petFilter = petSelect.titleForSegment(at: petSelect.selectedSegmentIndex)
        
        print (minPriceFilter)
        print (maxPriceFilter)
        print (bedroomFilter)
        print (distanceFilter)
        print(propertyFilter)
        print (petFilter)

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
