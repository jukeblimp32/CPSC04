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
    
    var pickerData = ["200", "300", "400", "500", "600", "700", "800", "900", "1000", "1100", "1200",
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
        bedroomNum.text = Int(sender.value).description
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
    }
    
    
    //ELMA HEREEEEE
    @IBAction func applyFilters(_ sender: Any) {
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
