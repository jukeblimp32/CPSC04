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
    
    var filters = [String]()
    
    var pickerData = ["Any", "200", "300", "400", "500", "600", "700", "800", "900", "1000", "1100", "1200",
    "1300", "1400", "1500", "1600", "1700", "1800", "1900", "2000", "2100", "2200", "2300", "2400", "2500", "2600", "2700", "2800", "2900", "3000"]
    
    
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

        var minPriceFilter = pickerData[pickerMin.selectedRow(inComponent: 0)]
        var maxPriceFilter = pickerData[pickerMax.selectedRow(inComponent: 0)]
        var bedroomFilter = bedroomNum.text
        var distanceFilter = String(format: "%.1f", self.slider.value)
        var propertyFilter = propTypeSelect.titleForSegment(at: propTypeSelect.selectedSegmentIndex)
        var petFilter = petSelect.titleForSegment(at: petSelect.selectedSegmentIndex)
        
        self.filters.append(minPriceFilter)
        self.filters.append(maxPriceFilter)
        self.filters.append(bedroomFilter!)
        self.filters.append(distanceFilter)
        self.filters.append(propertyFilter!)
        sleep(2)
        tabBarController?.selectedIndex = 0
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
