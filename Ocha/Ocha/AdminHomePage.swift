//
//  AdminHomePage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/3/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class AdminHomePage: UIViewController {
    
    @IBOutlet var manageListings: UIButton!
    
    @IBOutlet var approveListings: UIButton!
    
    @IBOutlet var manageUsers: UIButton!
    
    @IBOutlet var approveReviews: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.setHidesBackButton(true, animated:true);
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

