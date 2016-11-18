//
//  LandlordTabController.swift
//  Ocha
//
//  Created by Talkov, Leah C on 11/11/16.
//  Copyright © 2016 CPSC04. All rights reserved.
//

import UIKit

class LandlordTabController: UITabBarController {
    
    func viewDidAppear() {
        super.viewDidLoad()
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)
        //UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(UIColor.blueColor(), size: //CGSizeMake(tabBar.frame.width/5, tabBar.frame.height))
        // Do any additional setup after loading the view, typically from a nib.
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
