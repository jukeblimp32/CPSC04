//
//  ListingPage.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/20/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class ListingPage: UIViewController {
    
    @IBOutlet var image: UIImageView!
    
    @IBOutlet var address: UILabel!
    
    @IBOutlet var distance: UILabel!
    
    @IBOutlet var rooms: UILabel!
    
    @IBOutlet var rent: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
