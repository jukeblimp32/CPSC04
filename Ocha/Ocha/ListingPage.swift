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
    
    @IBOutlet weak var toHomePageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toHomePageButton.frame = CGRect(x: (view.frame.width) / 9, y: (view.frame.height) * (5/100), width: view.frame.width / 5 , height: 30)
        toHomePageButton.setTitle("Back", for: UIControlState.normal)
        toHomePageButton.titleLabel?.font = UIFont(name: address.font.fontName, size: 20)
        toHomePageButton.titleLabel?.textColor = UIColor.white
        toHomePageButton.backgroundColor = UIColor.init(red: 13.0/255, green: 144.0/255, blue: 161.0/255, alpha: 1)
        toHomePageButton.layer.cornerRadius = 4
        view.addSubview(toHomePageButton)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
